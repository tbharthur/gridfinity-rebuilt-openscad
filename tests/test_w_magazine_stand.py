"""
Focused geometry checks for the W magazine stand profile.
"""

from __future__ import annotations

import re
import subprocess
import math
from pathlib import Path
from tempfile import TemporaryDirectory


def render_profile_svg(pytestconfig) -> str:
    scad_path = pytestconfig.rootpath.joinpath("w-magazine-stand.scad")

    with TemporaryDirectory(prefix="w-mag-stand-") as tmpdir:
        tmpdir_path = Path(tmpdir)
        harness_path = tmpdir_path.joinpath("profile_harness.scad")
        harness_path.write_text(
            f"use <{scad_path}>;\n"
            "cross_section_2d();\n",
            encoding="utf-8",
        )

        svg_path = tmpdir_path.joinpath("profile.svg")
        subprocess.run(
            ["openscad", "-o", str(svg_path), str(harness_path)],
            check=True,
            capture_output=True,
            text=True,
        )
        return svg_path.read_text(encoding="utf-8")


def svg_path_points(svg_text: str) -> list[tuple[float, float]]:
    path_data = re.search(r'<path d="\s*(.*?)\s*"', svg_text, re.S)
    assert path_data, "OpenSCAD SVG output did not include a path"
    numbers = [float(token) for token in re.findall(r"-?\d+(?:\.\d+)?", path_data.group(1))]
    return list(zip(numbers[0::2], numbers[1::2]))


def valley_shoulder_segments(points: list[tuple[float, float]]) -> list[float]:
    platform_plus_valley_y = -20.0
    x_window = (40.0, 126.0)
    segments = []

    for (x1, y1), (x2, y2) in zip(points, points[1:]):
        if abs(y1 - y2) > 1e-6 or abs(y1 - platform_plus_valley_y) > 1e-6:
            continue
        if not (x_window[0] <= x1 <= x_window[1] and x_window[0] <= x2 <= x_window[1]):
            continue
        segments.append(abs(x2 - x1))

    return segments


def long_outer_face_segments(points: list[tuple[float, float]]) -> list[float]:
    segments = []
    wrapped_points = points[1:] + points[:1]

    for (x1, y1), (x2, y2) in zip(points, wrapped_points):
        if not ((y1 > -20 and y2 < -150) or (y2 > -20 and y1 < -150)):
            continue

        left_outer_run = max(x1, x2) < 50
        right_outer_run = min(x1, x2) > 120
        if not (left_outer_run or right_outer_run):
            continue

        segments.append(math.hypot(x2 - x1, y2 - y1))

    return segments


def test_inner_valleys_do_not_leave_long_flat_shoulders(pytestconfig):
    points = svg_path_points(render_profile_svg(pytestconfig))
    shoulders = valley_shoulder_segments(points)

    assert max(shoulders or [0]) <= 2.5, (
        "Inner valley still has long flat shoulders at the wall-to-bottom transition; "
        f"measured segments: {shoulders}"
    )


def test_outer_walls_are_not_single_long_straight_runs(pytestconfig):
    points = svg_path_points(render_profile_svg(pytestconfig))
    outer_runs = long_outer_face_segments(points)

    assert max(outer_runs or [0]) <= 120, (
        "Outer wall profile is still reading as one long straight segment; "
        f"measured segments: {outer_runs}"
    )
