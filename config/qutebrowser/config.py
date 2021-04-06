config.load_autoconfig(False)

c.auto_save.session = True

# TODO: https://github.com/qutebrowser/qutebrowser/issues/1044
#c.bindings.key_mappings = {
#    'jj': '<Escape>'
#}

# inspiration: https://hg.sr.ht/~jasonwryan/shiv/browse/.config/qutebrowser/config.py
c.colors.completion.fg = "#899CA1"
c.colors.completion.category.fg = "#F2F2F2"
c.colors.completion.category.bg = "#555555"
c.colors.completion.item.selected.fg = "white"
c.colors.completion.item.selected.match.fg = "#0080FF"
c.colors.completion.item.selected.bg = "#333333"
c.colors.completion.item.selected.border.top = "#333333"
c.colors.completion.item.selected.border.bottom = "#333333"
c.colors.completion.match.fg = "#66FFFF"
c.colors.statusbar.normal.fg = "#899CA1"
c.colors.statusbar.normal.bg = "#222222"
c.colors.statusbar.insert.fg = "#1E2127"
c.colors.statusbar.insert.bg = "#98C379"
c.colors.statusbar.command.bg = "#555555"
c.colors.statusbar.command.fg = "#F0F0F0"
c.colors.statusbar.caret.bg = "#5E468C"
c.colors.statusbar.caret.selection.fg = "white"
c.colors.statusbar.progress.bg = "#333333"
c.colors.statusbar.passthrough.bg = "#4779B3"
c.colors.statusbar.url.fg = c.colors.statusbar.normal.fg
c.colors.statusbar.url.success.http.fg = "#899CA1"
c.colors.statusbar.url.success.https.fg = "#53A6A6"
c.colors.statusbar.url.error.fg = "#8A2F58"
c.colors.statusbar.url.warn.fg = "#914E89"
c.colors.statusbar.url.hover.fg = "#2B7694"
c.colors.tabs.bar.bg = "#222222"
c.colors.tabs.even.fg = "#899CA1"
c.colors.tabs.even.bg = "#222222"
c.colors.tabs.odd.fg = "#899CA1"
c.colors.tabs.odd.bg = "#222222"
c.colors.tabs.selected.even.fg = "white"
c.colors.tabs.selected.even.bg = "#222222"
c.colors.tabs.selected.odd.fg = "white"
c.colors.tabs.selected.odd.bg = "#222222"
c.colors.tabs.indicator.start = "#222222"
c.colors.tabs.indicator.stop = "#222222"
c.colors.tabs.indicator.error = "#8A2F58"
c.colors.hints.bg = "#CCCCCC"
c.colors.hints.match.fg = "#000"
c.colors.downloads.start.fg = "black"
c.colors.downloads.start.bg = "#BFBFBF"
c.colors.downloads.stop.fg = "black"
c.colors.downloads.stop.bg = "#F0F0F0"
c.colors.keyhint.fg = "#FFFFFF"
c.colors.keyhint.suffix.fg = "#FFFF00"
c.colors.keyhint.bg = "rgba(0, 0, 0, 80%)"
c.colors.messages.error.bg = "#8A2F58"
c.colors.messages.error.border = "#8A2F58"
c.colors.messages.warning.bg = "#BF85CC"
c.colors.messages.warning.border = c.colors.messages.warning.bg
c.colors.messages.info.bg = "#333333"
c.colors.prompts.fg = "#333333"
c.colors.prompts.bg = "#DDDDDD"
c.colors.prompts.selected.bg = "#4779B3"
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.algorithm = "brightness-rgb"
c.colors.webpage.darkmode.grayscale.all = True

c.content.autoplay = False
c.content.blocking.adblock.lists = ['https://easylist.to/easylist/easylist.txt', 'https://easylist.to/easylist/easyprivacy.txt']
c.content.blocking.enabled = True
c.content.blocking.hosts.lists = ['https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts']
c.content.blocking.method = 'both'
c.content.blocking.whitelist = []
c.content.cookies.accept = 'no-3rdparty' # all / no-unknown-3rdparty / never
c.content.default_encoding = 'utf-8' # 'iso-8859-1'
c.content.dns_prefetch = True
c.content.geolocation = False
c.content.headers.do_not_track = True

c.downloads.position = "bottom"
c.downloads.location.prompt = False
c.downloads.location.directory = "~/tmp/"
c.downloads.position = "bottom"

c.editor.command = ["alacritty", "-e", "nvim", "-f", "{file}"]

c.fileselect.multiple_files.command = ["alacritty", "-e", "ranger", "--choosefiles={}"]
c.fileselect.single_file.command = ["alacritty", "-e", "ranger", "--choosefiles={}"]

c.session.lazy_restore = True

c.url.default_page = "about:blank"
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "emoji": "https://emojipedia.org/search/?q={}",
    "cstoen": "https://translate.google.com/#cs/en/{}",
    "cstoes": "https://translate.google.com/#cs/es/{}",
    "cstodk": "https://translate.google.com/#cs/dk/{}",
    "entocs": "https://translate.google.com/#en/cs/{}",
    "estocs": "https://translate.google.com/#es/cs/{}",
    "dktocs": "https://translate.google.com/#dk/cs/{}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "twitter": "https://twitter.com/search?q={}",
    "netflix": "https://www.netflix.com/search?q={}",
    "osm": "http://www.openstreetmap.org/search?query={}",
    "map": "https://www.google.cz/maps/place/{}",
    "wa": "http://www.wolframalpha.com/input/?i={}",
    "pacman": "https://archlinux.org/packages/?q={}",
    "wiki": "https://en.wikipedia.org/wiki/{}"
}

c.window.title_format = "[{scroll_pos}]{private}{audio} {current_title}{title_sep}qutebrowser"

config.bind('<Escape>', 'mode-leave', mode='passthrough')
# bash-like editing on input: https://gist.github.com/Gavinok/f9c310a66576dc00329dd7bef2b122a1
config.bind("<Ctrl-h>", "fake-key <Backspace>", "insert")
config.bind("<Ctrl-a>", "fake-key <Home>", "insert")
config.bind("<Ctrl-e>", "fake-key <End>", "insert")
config.bind("<Ctrl-b>", "fake-key <Left>", "insert")
config.bind("<Mod1-b>", "fake-key <Ctrl-Left>", "insert")
config.bind("<Ctrl-f>", "fake-key <Right>", "insert")
config.bind("<Mod1-f>", "fake-key <Ctrl-Right>", "insert")
config.bind("<Ctrl-p>", "fake-key <Up>", "insert")
config.bind("<Ctrl-n>", "fake-key <Down>", "insert")
config.bind("<Mod1-d>", "fake-key <Ctrl-Delete>", "insert")
config.bind("<Ctrl-d>", "fake-key <Delete>", "insert")
config.bind("<Ctrl-w>", "fake-key <Ctrl-Backspace>", "insert")
config.bind("<Ctrl-u>", "fake-key <Shift-Home><Delete>", "insert")
config.bind("<Ctrl-k>", "fake-key <Shift-End><Delete>", "insert")
config.bind("<Ctrl-x><Ctrl-e>", "open-editor", "insert")
