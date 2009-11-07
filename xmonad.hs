------------------------------------------------------------------------
--file:          ~/.xmonad/xmonad.hs
--author:        enko
--last modified: nov 2009
--vim:enc=utf-8: nu:ai:si:et:ts=4:sw=4:ft=xdefaults:
------------------------------------------------------------------------
-- XMonad

import XMonad
import System.IO
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid
import Data.List
-- Other

import XMonad.Operations
import XMonad.Config
import XMonad.Actions.CycleWS
import XMonad.Actions.MouseGestures
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Prompt
import XMonad.Prompt.Shell
import Data.Ratio ((%))
-- Hooks

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive 
-- Layout stuff

import XMonad.Layout.PerWorkspace
import XMonad.Layout.LayoutHints
-- Layouts

import XMonad.Layout.SimplestFloat
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
--import XMonad.Layout.Spacing

-- X11
import Graphics.X11.Xlib.Extras
import Foreign.C.Types (CLong)

-- Variables -----------------------------------------------------------
--

myTerminal               = "urxvt"
myBorderWidth            = 1
myModMask                = mod4Mask
myWorkspaces             = ["main", "web", "jabber", "hub"]-- ++ map show [5..9]
myFont                   = "-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*"

-- Color ---------------------------------------------------------------
--

myNormalBorderColor      = "#FFFFFF"
myFocusedBorderColor     = "#FF0000"
 
-- Keys bindings -------------------------------------------------------
--

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
 
      [ ((modMask,                 xK_p      ), spawn "dmenu_run -fn \"-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*\" -nb \"#131313\" -nf \"#BFBFBF\" -sb \"#2A2A2A\" -sf \"#FFA500\"")
      , ((modMask .|. shiftMask,   xK_Return ), spawn $ XMonad.terminal conf)
      , ((modMask,                 xK_t      ), spawn $ XMonad.terminal conf)
      , ((modMask .|. shiftMask,   xK_c      ), kill)
      , ((modMask,                 xK_r      ), shellPrompt defaultXPConfig)
      , ((modMask,                 xK_w      ), spawn "nitrogen --no-recurse --sort=alpha /mnt/data/wallpapers")
      , ((modMask,                 xK_s      ), spawn "sakura -e screen")
      , ((modMask,                 xK_Print  ), spawn "scrot -d 1 /home/enko/images/screenshots/%d.%m.%Y-%M%S.png") 
      -- file manager
      , ((modMask,                 xK_d      ), spawn "pcmanfm ~") 
      , ((modMask,                 xK_f      ), spawn "firefox")
      , ((modMask,                 xK_g      ), spawn "geany")
      -- music
      , ((modMask,                 xK_b      ), spawn "mpc next")
      , ((modMask,                 xK_v      ), spawn "mpc toggle")
      , ((modMask,                 xK_x      ), spawn "mpc stop")
      , ((modMask,                 xK_z      ), spawn "mpc prev")
      , ((modMask .|. controlMask, xK_b      ), spawn "mpc seek +2%")
      , ((modMask .|. controlMask, xK_z      ), spawn "mpc seek -2%")
      , ((modMask,                 xK_n      ), spawn "urxvt -e ncmpcpp")
      -- layouts
      , ((modMask,                 xK_space  ), sendMessage NextLayout)
      , ((modMask .|. shiftMask,   xK_space  ), setLayout $ XMonad.layoutHook conf)
      -- refresh
      --, ((modMask,                 xK_n      ), refresh)
      --, ((modMask .|. shiftMask, xK_w      ), withFocused toggleBorder)
 
      -- focus
      , ((modMask,                 xK_Tab    ), windows W.focusDown)
      , ((modMask,                 xK_j      ), windows W.focusDown)
      , ((modMask,                 xK_k      ), windows W.focusUp)
      , ((modMask,                 xK_m      ), windows W.focusMaster)
 
      -- swapping
      , ((modMask .|. shiftMask,   xK_j      ), windows W.swapDown  )
      , ((modMask .|. shiftMask,   xK_k      ), windows W.swapUp    )
 
      -- increase or decrease number of windows in the master area
      , ((modMask .|. controlMask, xK_h      ), sendMessage (IncMasterN 1))
      , ((modMask .|. controlMask, xK_l      ), sendMessage (IncMasterN (-1)))
 
      -- resizing
      , ((modMask,                 xK_h      ), sendMessage Shrink)
      , ((modMask,                 xK_l      ), sendMessage Expand)
      , ((modMask .|. shiftMask,   xK_h      ), sendMessage MirrorShrink)
      , ((modMask .|. shiftMask,   xK_l      ), sendMessage MirrorExpand)
      
      -- cycle through workspaces
      , ((modMask,                 xK_Right  ), moveTo Next (WSIs (return $ not . (=="SP") . W.tag)))
      , ((modMask,                 xK_Left   ), moveTo Prev (WSIs (return $ not . (=="SP") . W.tag)))

      -- move windows through workspaces
      , ((modMask .|. shiftMask,   xK_Right  ), shiftTo Next (WSIs (return $ not . (=="SP") . W.tag)))
      , ((modMask .|. shiftMask,   xK_Left   ), shiftTo Prev (WSIs (return $ not . (=="SP") . W.tag)))
      , ((modMask .|. controlMask, xK_Right  ), shiftTo Next EmptyWS)
      , ((modMask .|. controlMask, xK_Left   ), shiftTo Prev EmptyWS)

      -- quit, or restart
    --  , ((modMask .|. shiftMask, xK_q      ), io (exitWith ExitSuccess))
      , ((modMask .|. shiftMask,   xK_q      ), spawn "oblogout")
    --, ((modMask              ,   xK_q      ), spawn "killall conky dzen2 && sleep 0.5" >> restart "xmonad" True)
      , ((modMask                , xK_q      ), spawn "xmonad --recompile; xmonad --restart")
      , ((modMask .|. shiftMask,   xK_x      ), spawn "sudo shutdown -h now")
      ]
      ++
      
      -- mod-[1..9] %! Switch to workspace N
      -- mod-shift-[1..9] %! Move client to workspace N
      [((m .|. modMask, k), windows $ f i)
          | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_6]
          , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-- Mouse bindings ------------------------------------------------------
--

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
 
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))
     --[ ((modMask, button1), (mouseGesture gestures))
    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))
 
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))
 
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

gestures = M.fromList
         [ ([], focus)
         , ([U], \w -> focus w >> windows W.swapUp)
         , ([D], \w -> focus w >> windows W.swapDown)
         , ([R, D], \_ -> sendMessage NextLayout)
         ]
 

-- Layouts -------------------------------------------------------------
--
myLayout = tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     
-- Window rules --------------------------------------------------------
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
     -- just very simple
-- doFloat
    -- multimedia
    [ className =? "MPlayer"             --> doFloat
    , className =? "Smplayer"            --> doFloat
    , className =? "Vlc"                 --> doFloat
    , className =? "Sonata"              --> doFloat
    -- picture
    , className =? "Gimp"                --> doFloat
    , className =? "Nitrogen"            --> doFloat
    , className =? "GQview"              --> doFloat
    -- mail
    , className =? "Thunderbird-bin"     --> doFloat
    -- X stuff
    , className =? "Xmessage"            --> doFloat
    , className =? "XFontSel"            --> doFloat
    , className =? "XCalc"               --> doFloat
    -- other
    , className =? "Lxappearance"        --> doFloat
    , className =? "Sakura"              --> doFloat
    , className =? "Downloads"           --> doFloat
    , className =? "Firefox Preferences" --> doFloat
    , className =? "Save As..."          --> doFloat
    , className =? "Send file"           --> doFloat
    , className =? "Open"                --> doFloat
    , className =? "File Transfers"      --> doFloat
-- moveTo
    , className =? "Firefox"             --> moveTo "web"
    , className =? "Gajim.py"            --> moveTo "jabber"
    , className =? "Pidgin"              --> moveTo "jabber"
    , className =? "Linuxdcpp"           --> moveTo "hub"
-- doIgnore    
    , resource  =? "desktop_window"      --> doIgnore
    ] <+> manageMenus <+> manageDialogs
    where moveTo = doF . W.shift
--
-- AutoFloat -- (import Graphics.X11.Xlib.Extras,import Foreign.C.Types (CLong))

getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w

checkAtom name value = ask >>= \w -> liftX $ do
          a <- getAtom name
          val <- getAtom value
          mbr <- getProp a w
          case mbr of
            Just [r] -> return $ elem (fromIntegral r) [val]
            _ -> return False

checkDialog = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG"
checkMenu = checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"

manageMenus = checkMenu --> doFloat
manageDialogs = checkDialog --> doFloat

-- Whether focus follows the mouse pointer -----------------------------
--

myFocusFollowsMouse :: Bool
myFocusFollowsMouse =  True
 
-- Dzen2 stuff ---------------------------------------------------------
--

myStatusBar :: String
myStatusBar = "dzen2 -fn '-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*' -fg '#4D4D4D' -h 20 -sa c -x 0 -y 0 -w 1000 -e '' -ta l"

myConkyBar :: String
myConkyBar = "sleep 1 && conky -c ~/.conkyrc | dzen2 -fn '-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*' -fg '#4D4D4D' -h 20 -sa c -x 1000 -y 0 -e '' -ta r"
 
myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
      {   ppCurrent         = dzenColor "#A52A2A"  "black"      . pad
        , ppVisible         = dzenColor "#A52A2A"  ""           . pad
        , ppHidden          = dzenColor "#BFBFBF"  ""           . pad
        , ppHiddenNoWindows = dzenColor "#BFBFBF"  ""           . pad
        , ppUrgent          = dzenColor ""         "#BFBFBF"    . pad
        , ppWsSep           = ""
        , ppSep             = "|"
        , ppLayout          = dzenColor "#7F7F7F" "" 
        , ppTitle           = (" " ++) . dzenColor "#7F7F7F" "" . dzenEscape
        , ppOutput          = hPutStrLn h
      }
  where
    icon h = "^fg()" ++ h
    fill :: String -> Int -> String
    fill h i = "^ca(1,xdotool key super+space)^p(" ++ show i ++ ")" ++ "^p(" ++ h ++ ")" ++ "^p(" ++ show i ++ ")^ca()"

-- Main ----------------------------------------------------------------

main :: IO ()
main = do 
       workspaceBarPipe <- spawnPipe myStatusBar 
       conkyBarPipe <- spawnPipe myConkyBar
--       spawn      "xcompmgr"
       
       -- and finally start xmonad:
       
       xmonad $ withUrgencyHook NoUrgencyHook defaultConfig {
          terminal           = myTerminal,
          focusFollowsMouse  = myFocusFollowsMouse,
          borderWidth        = myBorderWidth,
          modMask            = myModMask,
          workspaces         = myWorkspaces,
          normalBorderColor  = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          keys               = myKeys,
          mouseBindings      = myMouseBindings,
          manageHook         = myManageHook <+> manageDocks,
          logHook            = myLogHook workspaceBarPipe >> fadeInactiveLogHook 0xdddddddd,
          layoutHook         = avoidStruts $ myLayout
    }
