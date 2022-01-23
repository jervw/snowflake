from libqtile.dgroups import simple_key_binder
import os
import socket
import subprocess
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List


mod = "mod4"  # Super as modkey
myTerm = "alacritty"  # Terminal
myBrowser = "firefox"  # Browser

keys = [
    # The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc="Launch Terminal"),
    Key(
        [mod],
        "d",
        lazy.spawn("rofi -i -show drun -icon-theme 'Papirus' -show-icons"),
        desc="Run Rofi with icons",
    ),
    Key([mod], "b", lazy.spawn(myBrowser), desc="Run Firefox"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle through layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill active window"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "e", lazy.shutdown(), desc="Shutdown Qtile"),
    # Switch focus to specific monitor (out of three)
    Key([mod], "w", lazy.to_screen(0), desc="Keyboard focus to monitor 1"),
    Key([mod], "e", lazy.to_screen(1), desc="Keyboard focus to monitor 2"),
    # Vim like window controls
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down;"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.section_left(),
        desc="Move windows left",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down(),
        desc="Move windows down",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up(),
        desc="Move windows up",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.section_right(),
        desc="Move windows right",
    ),
    Key(
        [mod],
        "n",
        lazy.layout.normalize(),
        desc="normalize window sizes",
    ),
    Key(
        [mod],
        "m",
        lazy.layout.maximize(),
        desc="toggle window between minimum and maximum sizes",
    ),
    Key(
        [mod, "shift"],
        "space",
        lazy.window.toggle_floating(),
        desc="toggle floating",
    ),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="toggle fullscreen"),
]

groups = [
    Group("", layout="monadtall"),
    Group("爵", layout="monadtall"),
    Group("", layout="monadtall"),
    Group("ﭮ", layout="monadtall"),
    Group("", layout="monadtall"),
    Group("", layout="monadtall"),
]

# MOD4 + index Number : Switch to Group[index]
# MOD4 + shift + index Number : Send active window to another Group
dgroups_key_binder = simple_key_binder("mod4")

layout_theme = {
    "border_width": 2,
    "margin": 32,
    "border_focus": "F28FAD",
    "border_normal": "161320",
}

layouts = [
    # layout.MonadWide(**layout_theme),
    # layout.Stack(stacks=2, **layout_theme),
    # layout.Columns(**layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.Tile(shift_windows=True, **layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.Zoomy(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Floating(**layout_theme),
]

colors = [
    ["#161320", "#161320"],
    ["#1E1E2E", "#1E1E2E"],
    ["#FAE3B0", "#FAE3B0"],
    ["#F28FAD", "#F28FAD"],
    ["#ABE9B3", "#ABE9B3"],
    ["#F8BD96", "#F8BD96"],
    ["#96CDFB", "#96CDFB"],
    ["#DDB6F2", "#DDB6F2"],
    ["#89DCEB", "#89DCEB"],
    ["#C9CBFF", "#C9CBFF"],
]

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

# Widget Settings #
widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=15,
    padding=10,
    background=colors[0],
)
extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
        # Left side
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[2],
        ),
        widget.GroupBox(
            font="JetBrainsMono Nerd Font",
            fontsize=16,
            margin_y=4,
            margin_x=-2,
            padding_y=5,
            padding_x=20,
            borderwidth=2,
            active=colors[2],
            inactive=colors[7],
            rounded=False,
            highlight_color=colors[1],
            highlight_method="line",
            this_current_screen_border=colors[6],
            this_screen_border=colors[4],
            other_current_screen_border=colors[6],
            other_screen_border=colors[4],
            foreground=colors[2],
        ),
        widget.TextBox(
            text="|",
            font="JetBrainsMono Nerd Font",
            background=colors[0],
            foreground="474747",
            padding=2,
            fontsize=16,
        ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            foreground=colors[2],
            padding=0,
            scale=0.7,
        ),
        widget.CurrentLayout(
            foreground=colors[2],
        ),
        widget.TextBox(
            text="|",
            font="JetBrainsMono Nerd Font",
            background=colors[0],
            foreground="474747",
            padding=2,
            fontsize=16,
        ),
        widget.WindowName(foreground=colors[6], padding=0),
        widget.Systray(padding=5),
        widget.TextBox(
            text="|",
            font="JetBrainsMono Nerd Font",
            background=colors[0],
            foreground="474747",
            padding=10,
            fontsize=16,
        ),
        widget.Sep(
            linewidth=0,
            foreground=colors[0],
        ),
        # Right side
        # widget.Net(
        #     interface="enp39s0",
        #     format="{down} ↓↑ {up}",
        #     foreground=colors[3],
        # ),
        widget.ThermalSensor(
            foreground=colors[4],
            threshold=90,
            fmt=" {}",
        ),
        widget.Memory(
            foreground=colors[6],
            fmt="{}",
        ),
        widget.Volume(
            foreground=colors[7],
            fmt=" {}",
        ),
        widget.KeyboardLayout(
            foreground=colors[8],
            fmt=" {}",
        ),
        widget.Clock(foreground=colors[9], format=" %H:%M"),
        widget.Sep(
            linewidth=0,
            padding=6,
            foreground=colors[2],
        ),
    ]
    return widgets_list


# Screen 1 widgets, cutting tray icon
def init_widgets1():
    widgets_screen1 = init_widgets_list()
    # Slicing removes unwanted widgets (systray) on Monitor 1
    return widgets_screen1


# Screen 2 widgets
def init_widgets2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2


def init_screens():
    return [
        Screen(top=bar.Bar(widgets=init_widgets1(), opacity=1, size=30)),
        Screen(top=bar.Bar(widgets=init_widgets2(), opacity=1, size=30)),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets1()
    widgets_screen2 = init_widgets2()


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)


def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)


def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)


mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="kdenlive"),  # kdenlive
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


wmname = "qtile"
