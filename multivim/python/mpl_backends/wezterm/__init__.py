import json
import os
import subprocess
from io import BytesIO

from matplotlib.backend_bases import FigureManagerBase, _Backend
from matplotlib.backends.backend_agg import FigureCanvasAgg

FIGURE_RELATIVE_WIDTH = float(
    os.environ.get(
        "MPLBACKEND_WEZTERM_FIGURE_RELATIVE_WIDTH",
        80,
    )
)

WEZTERM_PANE_ID = int(os.environ["WEZTERM_PANE"])


def wezterm_pane_size(pane_id: int) -> tuple[int, int]:
    panes = json.loads(
        subprocess.check_output(["wezterm", "cli", "list", "--format=json"])
    )

    active_pane = [pane for pane in panes if pane["pane_id"] == pane_id][0]

    width = int(active_pane["size"]["pixel_width"])
    height = int(active_pane["size"]["pixel_height"])

    return (width, height)


class FigureManagerWezterm(FigureManagerBase):
    def show(self):
        pane_width_px, _ = wezterm_pane_size(WEZTERM_PANE_ID)
        figure_width_inches, _ = self.canvas.figure.get_size_inches()

        dpi = (FIGURE_RELATIVE_WIDTH / 100) * pane_width_px / figure_width_inches

        with BytesIO() as buf:
            self.canvas.figure.savefig(buf, format="png", dpi=dpi)
            subprocess.run(["wezterm", "imgcat"], input=buf.getbuffer())


class FigureCanvasWezterm(FigureCanvasAgg):
    manager_class = FigureManagerWezterm


@_Backend.export
class _BackendICatAgg(_Backend):
    FigureCanvas = FigureCanvasWezterm
    FigureManager = FigureManagerWezterm
