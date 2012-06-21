-- ~/.xmonad/xmonad.hs
-- Imports {{{

-- Basics {{{
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import System.IO
import System.Exit
import XMonad.Operations
import XMonad.Actions.CycleWS
import qualified XMonad.StackSet as W
import qualified Data.Map as M
-- }}}

-- Extras {{{
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.PerWorkspace (onWorkspace, onWorkspaces)
import XMonad.Layout.Reflect (reflectHoriz)
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
-- }}}
--}}} 

-- Main {{{
main = do
    dzenLeftBar <- spawnPipe myXmonadBar
    dzenRightBar <- spawnPipe myStatusBar
    xmonad $ defaultConfig
      { terminal            = myTerminal
      , workspaces          = myWorkspaces
      , keys                = myKeys
      , modMask             = myModMask
      , layoutHook          = mylayoutHook
      , manageHook          = myManageHook  <+> manageDocks
      , logHook             = myLogHook dzenLeftBar >> fadeInactiveLogHook 0xdddddddd
      , normalBorderColor   = colorNormalBorder
      , focusedBorderColor  = colorFocusedBorder
      , borderWidth         = 2
      , handleEventHook     = docksEventHook
}
--}}}
 
-- Config {{{
-- Dzen/Conky
myXmonadBar = "dzen2 -x '0' -y '0' -h '20' -w \"$(expr $(xrandr --current | sed -n '1 p' | sed  's/.*current *\\([0-9]*\\).*/\\1/') - 152)\" -ta 'l' -fg '#FFFFFF' -bg '#000000'"
myStatusBar = "conky -c /USER_PATH/.xmonad/.conky_dzen | dzen2 -x '0' -y \"$(expr $(xrandr --current | sed -n '1 p' | sed  's/.*current *[0-9]* *x *\\([0-9]*\\).*/\\1/') - 18)\" -w \"$(xrandr --current | sed -n '1 p' | sed  's/.*current *\\([0-9]*\\).*/\\1/')\" -h '18' -ta 'c' -bg '#000000' -fg '#FFFFFF'"
myBitmapsDir = "/USER_PATH/.xmonad/dzen2"

-- Define Terminal
myTerminal      = "urxvtcd"

-- Define modMask
myModMask :: KeyMask
myModMask = mod4Mask

-- Define workspaces
myWorkspaces    = ["1:prim", "2:seco", "3:tert", "4:quat", "5:fs", "6:audio", "7:video", "8:social", "9:web"]
--}}}
 
-- Hooks {{{
-- ManageHook {{{
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
    [ [resource     =? r            --> doIgnore            |   r   <- myIgnoresResource    ] -- ignore desktop
    , [className    =? c            --> doShift  "5:fs"     |   c   <- myFSClass            ] -- move file system stuff (e.g. xfe) to fs.
    , [className    =? c            --> doShift  "6:audio"  |   c   <- myAudioClass         ] -- move audo stuff (e.g. spotify) to audio.
    , [name         =? n            --> doShift  "6:audio"  |   n   <- myAudioName          ] -- move audo stuff (e.g. spotify) to audio.
    , [className    =? c            --> doShift  "7:video"  |   c   <- myVideoClass         ] -- move video stuff (e.g. mplayer, vlc,gpicview, etc.) to video.
    , [className    =? c            --> doShift  "8:social" |   c   <- mySocialClass        ] -- move social stuff (e.g. irc) to social.
    , [className    =? c            --> doShift  "9:web"    |   c   <- myWebsClass          ] -- move web-ish stuff (e.g. Firefox, Chromium, etc.) to web.
    , [className    =? c            --> doCenterFloat       |   c   <- myFloatsClass        ] -- float my floats
    , [name         =? n            --> doCenterFloat       |   n   <- myNamesName          ] -- float my names
    , [isFullscreen                 --> myDoFullFloat                                       ] -- floats a fullscreen
    ])
 
    where
 
        role      = stringProperty "WM_WINDOW_ROLE"
        name      = stringProperty "WM_NAME"
 
        -- classnames
        myFloatsClass       = ["Smplayer", "MPlayer", "VirtualBox", "Xmessage", "XFontSel", "Downloads", "Wicd-client.py", "rdesktop", "System-config-printer", "feh", "gmrun", "Xscreensaver-demo", "Galculator", "Gimp", "Xfce4-power-manager-settings", "st-256color", "Vlc"]
        myFSClass           = ["Xfe", "Xfw", "Xfv", "Xfi", "Xfp", "Xarchiver"]
        myWebsClass         = ["Firefox", "Google-chrome", "Chromium", "Chromium-browser", "Xombrero"] -- Vimprobable I reserve as my swiss army knife browser.
        myVideoClass        = ["Boxee", "Trine", "Gpicview", "Vlc", "Guvcview"]
        myAudioClass        = ["Rhythmbox", "Spotify"]
        mySocialClass       = ["Pidgin", "Buddy List"]
 
        -- resources
        myIgnoresResource   = ["desktop", "desktop_window", "notify-osd", "stalonetray", "trayer"]
 
        -- names
        myNamesName         = ["bashrun", "Google Chrome Options", "Chromium Options"]
        myAudioName         = ["pianobar", "CMUS_VERSION"]
 
-- a trick for fullscreen but stil allow focusing of other WSs
-- I'm actually not sure this works... It certainly doesn't with Chromium when it is in fullscreen.
myDoFullFloat :: ManageHook
myDoFullFloat = doF W.focusDown <+> doFullFloat
-- }}}

mylayoutHook  = avoidStruts $ tiled ||| Mirror tiled ||| simpleFloat ||| Full
                    where tiled =  ResizableTall 1 (2/100) (1/2) []
 
--Bar
-- I've been having some problems with docking the bars. Namely, recompiling & restarting xmonad does not automatically dock the bars. Usually, cycling through the layouts will dock the bars, but not always. This happens though trayer docks just fine... Maybe I'll solve this later, when I know Haskell, and can put together a decent xmonad.hs.
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#000000" . pad
      , ppVisible           =   dzenColor "white" "#000000" . pad
      , ppHidden            =   dzenColor "white" "#000000" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#000000" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#000000" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#000000" .
                                (\x -> case x of
                                    "ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "white" "#000000" . dzenEscape
      , ppOutput            =   hPutStrLn h
    }
 
--}}}

-- Theme {{{
-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
colorBlack          = "#000000"
colorGrey           = "#666666"
 
colorNormalBorder   = "#CCCCC6"
colorFocusedBorder  = "#fd971f"
-- }}}

-- Key mapping {{{
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ 
    -- Programs
      ((modMask,                    xK_p        ), spawn "/USER_PATH/local/bin/dmenu_run -fn '-*-terminus-medium-r-normal-*-17-*-*-*-*-*-*-*'") 
    , ((modMask .|. shiftMask,      xK_p        ), spawn "gmrun")
    , ((modMask .|. shiftMask,      xK_Return   ), spawn $ XMonad.terminal conf)
    , ((modMask .|. controlMask,    xK_Return   ), spawn "/USER_PATH/local/bin/st") --Opens up st.
    , ((modMask .|. shiftMask,      xK_x        ), kill)
    , ((modMask .|. controlMask,    xK_l        ), spawn "xscreensaver-command --lock") --locks X11.
    , ((0,                          xK_Print    ), spawn "scrot -m '%Y-%m-%d_%H-%M-%S.png' -e 'mv $f ~/Pictures/screenshots'") -- screenshot of the whole screen.
    , ((shiftMask,                  xK_Print    ), spawn "sleep 0.2; scrot -s '%Y-%m-%d_%H-%M-%S.png' -e 'mv $f ~/Pictures/screenshots'") -- screenshot of a selected rectangle.
    , ((modMask,                    xK_i        ), spawn "/USER_PATH/local/bin/vimprobable2") -- 'i' for internet.
    , ((modMask,                    xK_f        ), spawn "xfe") -- 'f' for "file system".

    -- Media Keys
    -- I don't have a media keyboard at work, so this isn't always useful... But that's why there is the volume dock.
    , ((0,                          0x1008ff12  ), spawn "amixer -q sset Headphone toggle")        -- XF86AudioMute
    , ((0,                          0x1008ff11  ), spawn "amixer -q sset Headphone 5%-")   -- XF86AudioLowerVolume
    , ((0,                          0x1008ff13  ), spawn "amixer -q sset Headphone 5%+")   -- XF86AudioRaiseVolume
 
    -- layouts
    , ((modMask,                    xK_space    ), sendMessage NextLayout)                      -- switch to next layout
    , ((modMask .|. shiftMask,      xK_space    ), setLayout $ XMonad.layoutHook conf)          -- reset layout on current desktop to default
    , ((modMask,                    xK_b        ), sendMessage ToggleStruts)                    -- toggle the statusbars
    , ((modMask,                    xK_n        ), refresh)
    , ((modMask,                    xK_Tab      ), windows W.focusDown)                         -- move focus to next window
    , ((modMask,                    xK_j        ), windows W.focusDown)
    , ((modMask,                    xK_k        ), windows W.focusUp  )
    , ((modMask .|. shiftMask,      xK_j        ), windows W.swapDown)                          -- swap the focused window with the next window
    , ((modMask .|. shiftMask,      xK_k        ), windows W.swapUp)                            -- swap the focused window with the previous window
    , ((modMask,                    xK_Return   ), windows W.swapMaster)
    , ((modMask,                    xK_t        ), withFocused $ windows . W.sink)              -- Push window back into tiling
    , ((modMask,                    xK_h        ), sendMessage Shrink)                          -- %! Shrink a master area
    , ((modMask,                    xK_l        ), sendMessage Expand)                          -- %! Expand a master area
    , ((modMask,                    xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                    xK_period   ), sendMessage (IncMasterN (-1)))
 
    -- workspaces
    , ((modMask,                   xK_Right     ), nextWS)
    , ((modMask .|. shiftMask,     xK_Right     ), shiftToNext)
    , ((modMask,                   xK_Left      ), prevWS)
    , ((modMask .|. shiftMask,     xK_Left      ), shiftToPrev)
 
    -- quit, or restart
    , ((modMask .|. shiftMask,      xK_q        ), io (exitWith ExitSuccess))
    , ((modMask,                    xK_q        ), spawn "killall conky dzen2 && /USER_PATH/local/bin/xmonad --recompile && /USER_PATH/local/bin/xmonad --restart")
    , ((modMask,                    xK_r        ), spawn "/USER_PATH/local/bin/xmonad --restart")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
 
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
 
--}}}
-- vim:foldmethod=marker sw=4 sts=4 ts=4 tw=0 et ai 
