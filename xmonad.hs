------------------------------------------------------------------------
--
--file:          ~/.xmonad/xmonad.hs
--author:        enko (remake original file by pbrisbin)
--last modified: nov 2009
--
------------------------------------------------------------------------
--
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows  (rotFocusedUp, rotFocusedDown)
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WithAll       (killAll,withAll,withAll')

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.IM
import XMonad.Layout.LayoutHints    (layoutHintsWithPlacement)
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace   (onWorkspace)
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane

import XMonad.Util.EZConfig         (additionalKeysP)
import XMonad.Util.Loggers          (maildirNew,dzenColorL,wrapL)
import XMonad.Util.Run              (spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.WindowProperties (getProp32s)

import Data.List
import Data.Monoid
import Data.Ratio

import System.IO
import System.Exit

import qualified Data.Map        as M
import qualified XMonad.StackSet as W

--import Foreign.C.Types (CLong)
--import Graphics.X11.Xlib
--import Graphics.X11.Xlib.Extras

-- Variables -----------------------------------------------------------
--
myTerminal               = "urxvtc"
myWorkspaces             = ["main","web","chat","hub","TV"] ++ map show [6..9]
myXFTFont                = "xft:Liberation-12"   -- see 'Status Bars' for the dzen font
myModMask                = mod4Mask
myNormalBorderColor      = colorBG
myFocusedBorderColor     = colorFG3
myBorderWidth            = 1
conkyFile                = "~/.dzenconkyrc" 
--
-- Color ---------------------------------------------------------------
--
colorBG                  = "#303030"         -- background
colorFG                  = "#7F7F7F"         -- foreground
colorFG2                 = "#A52A2A"         -- foreground w/ emphasis
colorFG3                 = "#FFFFFF"         -- foreground w/ strong emphasis
colorUrg                 = "#FFFF00"         -- urgent

barHeight                = 20
monitorWidth             = 1680              -- two statusbars will span this width
leftBarWidth             = 1160              -- right bar will span difference

-- Keys bindings -------------------------------------------------------
--
myKeys = [ ("M-S-m"             , spawn myMail                 ) -- open mail client
         , ("M-S-i"             , spawn myCHAT                 ) -- open chat client
         , ("M-S-<Return>"      , spawn myTerminal             ) -- open terminal-urxvt
         , ("M-S-c"             , kill                         ) -- Close fucused window
         --
         , ("M-p"               , spawn  "dmenu_run -fn '-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*' -nb '#303030' -nf '#BFBFBF' -sb '#A52A2A' -sf '#dcdccc'") -- run dmenu
         , ("M-<Print>"         , spawn  "scrot -e 'mv $f ~/images/screenshots'" ) -- make screenshot
         , ("M-w"               , spawn  "nitrogen --no-recurse --sort=alpha /mnt/data/wallpapers") -- open wallpaper choice
         , ("M-f"               , spawn   myBrowser            ) -- Open web client
         , ("M-d"               , spawn  "pcmanfm ~"           ) -- Open filemanager
         , ("M-g"               , spawn  "geany"               ) -- Open gui texteditor
         , ("M-s"               , spawn  "sakura -e screen"    ) -- Open terminal-sakura      
         , ("M-`"               , spawn  "eject -T /dev/sr0"   ) -- Open / close cdrom
         , ("M-e"               , spawn  "urxvt -e vim ~/.xmonad/xmonad.hs") -- Edit this file

         -- imports required for these
         , ("M-r"               , scratchPad                   ) -- spawn scratch pad terminal
         , ("M-S-w"             , killAll                      ) -- Close all windows on current ws
         , ("M-<R>"             , moveTo Next (WSIs (return $ not . (=="SP") . W.tag))) 
         , ("M-<L>"             , moveTo Prev (WSIs (return $ not . (=="SP") . W.tag)))
         , ("M-S-<R>"           , shiftToNext >> nextWS        ) -- Shift window to ws and follow it
         , ("M-S-<L>"           , shiftToPrev >> prevWS        ) -- Shift window to ws and follow it
         , ("M-C-k"             , rotFocusedUp                 ) -- Rotate windows up through current focus
         , ("M-C-j"             , rotFocusedDown               ) -- Rotate windows down through current focus
         , ("M-o"               , sendMessage MirrorShrink     ) -- Shink slave panes vertically
         , ("M-i"               , sendMessage MirrorExpand     ) -- Expand slave panes vertically
         , ("M-<Backspace>"     , focusUrgent                  ) -- Focus most recently urgent window
         , ("M-S-<Backspace>"   , clearUrgents                 ) -- Make urgents go away
         , ("M-S-l"             , sendMessage ToggleStruts     )

         -- Multimedia
         , ("M-v"               , spawn "mpc toggle"           ) -- play/pause mpd
         , ("M-x"               , spawn "mpc stop"             ) -- stop mpd
         , ("M-z"               , spawn "mpc prev"             ) -- prev song
         , ("M-b"               , spawn "mpc next"             ) -- next song
         , ("M-S-b"             , spawn "mpc seek +2%"         ) -- rewind forward
         , ("M-S-z"             , spawn "mpc seek -2%"         ) -- rewind back
         , ("<XF86AudioMute>"       , spawn "amixer -q set Master toggle" ) -- toggle mute
         , ("<XF86AudioLowerVolume>", spawn "amixer -q set MPD 3%- unmute") -- volume down
         , ("<XF86AudioRaiseVolume>", spawn "amixer -q set MPD 3%+ unmute") -- volume up
 
         -- see below
         , ("M-q"               , spawn  myRestart             ) -- Restart xmonad
         , ("M-S-q"             , spawn "sudo reboot"          ) -- Reboot system
         , ("M-C-x"             , spawn  myShutdown            ) -- Off system
         ]

         where

           scratchPad = scratchpadSpawnActionTerminal myTerminal

           myBrowser  = "firefox"
           myMail     = myTerminal ++ " -e mutt"
           myCHAT     = myTerminal ++ " -e mcabber"

           -- killall conky/dzen2 (only if running) before executing default restart command
           myRestart  = "for pid in `pgrep conky`; do kill -9 $pid; done && " ++
                        "for pid in `pgrep dzen2`; do kill -9 $pid; done && " ++
                        "xmonad --recompile && xmonad --restart "
           myShutdown = "play /mnt/data/Themes/system_sound/La2/shutdown.wav && sudo shutdown -h now"
                       
-- Layouts -------------------------------------------------------------
--
myLayout = avoidStruts $ onWorkspace "web"  webLayouts $ 
                         onWorkspace "chat" imLayout   $ 
                         standardLayouts

  where
    
    standardLayouts      = tiled ||| Mirror tiled ||| tabLayout ||| full
    webLayouts           = tabLayout ||| twoPane ||| full

    -- im roster on left tenth, standardLayouts in other nine tenths
    imLayout             = withIM (1/10) imProp standardLayouts

    -- this property will be in the roster slot of imLayout
    imProp               = Role "roster"

    tiled                = hinted (ResizableTall nmaster delta ratio [])
    tabLayout            = hinted (tabbedBottom shrinkText myTabConfig)
    twoPane              = hinted (TwoPane delta (1/2))
    full                 = hinted (noBorders Full)
   
    -- like hintedTile but for any layout
    hinted l             = layoutHintsWithPlacement (0,0) l

    nmaster              = 1
    delta                = 3/100
    ratio                = toRational (2/(1 + sqrt 5 :: Double)) -- golden ratio

-- custom tab bar theme
myTabConfig :: Theme
myTabConfig = defaultTheme
  { fontName             = myXFTFont
  , decoHeight           = 20

  -- inactive
  , inactiveColor        = colorBG
  , inactiveBorderColor  = colorFG
  , inactiveTextColor    = colorFG
  
  -- active
  , activeColor          = colorBG
  , activeBorderColor    = colorFG2
  , activeTextColor      = colorFG3

  -- urgent
  , urgentColor          = colorUrg
  , urgentBorderColor    = colorBG
  , urgentTextColor      = colorBG
  }
  
-- Window rules --------------------------------------------------------
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = (composeAll . concat $
  [ [resource  =? r                 --> doIgnore         |  r    <- myIgnores] -- ignore desktop
  , [className =? c                 --> doShift "web"    |  c    <- myWebs   ] -- move browsers to web
  , [className =? c                 --> doShift "hub"    |  c    <- myHubs   ] -- move to hub
  , [className =? c                 --> doShift "TV"     |  c    <- myTV     ] -- move to TV
  , [title     =? t                 --> doShift "chat"   |  t    <- myChatT  ] -- move chats to chat
  , [className =? c                 --> doShift "chat"   | (c,_) <- myIM     ] -- move chats to chat
  , [className =? c <&&> role /=? r --> doFloat          | (c,r) <- myIM     ] -- float all ims but roster
  , [className =? c                 --> doCenterFloat    |  c    <- myFloats ] -- float my floats
  , [name      =? n                 --> doCenterFloat    |  n    <- myNames  ] -- float my names
  ]) <+> manageTypes <+> manageDocks <+> manageScratchPad

  where

    role      = stringProperty "WM_WINDOW_ROLE"
    name      = stringProperty "WM_NAME"

    -- [("ClassName","Role")]
    myIM      = [("Gajim.py","roster")]

    -- titles
    myChatT   = ["mcabber"]

    -- classnames
    myFloats  = ["MPlayer","Smplayer","VirtualBox","Xmessage",
                 "Save As...","XFontSel","XCalc","Lxappearance","Sakura",
                 "Firefox Preferences","Downloads","Send file","Open",
                 "File Transfers","Sonata","Nitrogen","GQview"]
                 
    myWebs    = ["Firefox"]

    myHubs    = ["Linuxdcpp"]
    
    myTV      = ["Vlc"]

    -- resources
    myIgnores = ["desktop","desktop_window","trayer"]

    -- names
    myNames   = ["bashrun"]

-- manage the scratchpad
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)

  where

    -- height, width as % screensize
    h = 0.4
    w = 0.6

    -- top center
    t = 0
    l = (1 - w) / 2

-- modified version of manageDocks
manageTypes :: ManageHook
manageTypes = checkType --> doCenterFloat

checkType :: Query Bool
checkType = ask >>= \w -> liftX $ do
  m   <- getAtom    "_NET_WM_WINDOW_TYPE_MENU"
  d   <- getAtom    "_NET_WM_WINDOW_TYPE_DIALOG"
  u   <- getAtom    "_NET_WM_WINDOW_TYPE_UTILITY"
  mbr <- getProp32s "_NET_WM_WINDOW_TYPE" w

  case mbr of
    Just [r] -> return $ elem (fromIntegral r) [m,d,u]
    _        -> return False

-- Dzen2 status bars ---------------------------------------------------
--
-- use a custom function to build two dzen2 bars
--
-- for non xft use something like this instead:
--  
myDzenFont = "-xos4-terminus-bold-r-*-*-16-*-*-*-*-*-iso10646-*"
myDzenFont :: String
--myDzenFont = drop 4 myXFTFont -- strip the 'xft:' part

makeDzen :: Int -> Int -> Int -> Int -> String -> String
makeDzen x y w h a = "dzen2 -p" ++
                     " -ta "    ++ a          ++
                     " -x "     ++ show x     ++
                     " -y "     ++ show y     ++
                     " -w "     ++ show w     ++
                     " -h "     ++ show h     ++
                     " -fn '"   ++ myDzenFont ++ "'" ++
                     " -fg '"   ++ colorFG    ++ "'" ++
                     " -bg '"   ++ colorBG    ++ "' -e 'onstart=lower'"

-- define the bars

myLeftBar   = makeDzen 0 0 leftBarWidth barHeight "l"
myRightBar  = "conky -c " ++ conkyFile ++ " | " ++ makeDzen leftBarWidth 0 (monitorWidth - leftBarWidth) barHeight "r"

-- LogHook

myLogHook :: Handle -> X ()
myLogHook h = (dynamicLogWithPP $ defaultPP
  { ppCurrent         = dzenColor colorBG  colorFG2 . pad
  , ppUrgent          = dzenColor colorBG  colorUrg . dzenStrip
  , ppLayout          = dzenFG    colorFG2 . myRename
  , ppHidden          = dzenFG    colorFG2 . noScratchPad
  , ppTitle           = shorten 50
  , ppHiddenNoWindows = namedOnly
  , ppExtras          = [myMail]
  , ppSep             = " "
  , ppWsSep           = ""
  , ppOutput          = hPutStrLn h
  })  >> updatePointer (Relative 0.95 0.95) >> myFadeInactive 0.75

  where

    -- thanks byorgey (this filters out NSP too)
    namedOnly ws = if any (`elem` ws) ['a'..'z'] then pad ws else ""

    -- my own filter out scratchpad function
    noScratchPad ws = if all (`elem` ws) "NSP" then "" else pad ws

    -- L needed for loggers
    dzenFG  c = dzenColor  c ""
    dzenFGL c = dzenColorL c "" 

    myMail    = wrapL "  Mail: " "" . dzenFGL colorFG2 $ maildirNew myMailDir
    myMailDir = "/home/enko/GMail/INBOX"

    myRename = (\x -> case x of
               "Hinted ResizableTall"          -> "/ /-/ "
               "Mirror Hinted ResizableTall"   -> "/-,-/ "
               "Hinted Tabbed Bottom Simplest" -> "/.../ "
               "Hinted TwoPane"                -> "/ / / "
               "Hinted Full"                   -> "/   / "
               
               _                               -> x ++ " "
               ) . stripIM

    stripIM s = if "IM " `isPrefixOf` s then drop (length "IM ") s else s

-- Other ---------------------------------------------------------------

-- FadeInactive *HACK* --
--
-- you can probably just use the standard:
--
--   >> fadeInactiveLogHook (Ratio)
--
-- i use this rewrite that checks layout, because xcompmgr is
-- epic fail for me on some layouts
--

-- sets the opacity of inactive windows to the specified amount
-- *unless* the current layout is full or tabbed
myFadeInactive :: Rational -> X ()
myFadeInactive = fadeOutLogHook . fadeIf (isUnfocused <&&> isGoodLayout)

-- returns True if the layout description does not contain words
-- "Full" or "Tabbed"
isGoodLayout:: Query Bool
isGoodLayout = liftX $ do
  l <- gets (description . W.layout . W.workspace . W.current . windowset)
  return $ not $ any (`isInfixOf` l) ["Full","Tabbed"]
   
--

-- MySpawnHook *HACK* --
--
-- spawn an arbitrary command on urgent
--
data MySpawnHook = MySpawnHook String deriving (Read, Show)

instance UrgencyHook MySpawnHook where
    urgencyHook (MySpawnHook s) w = spawn $ s

-- 'ding!' on urgent (gajim has fairly unnannoying sounds thankfully)
myUrgencyHook = MySpawnHook "play -q /usr/share/gajim/data/sounds/bounce.wav" 
--
-- Main ----------------------------------------------------------------
--
main = do
  d <- spawnPipe myLeftBar
  spawn myRightBar
  spawn "xcompmgr"
  -- and finally start xmonad:
  xmonad $ withUrgencyHook myUrgencyHook $ defaultConfig
    { terminal           = myTerminal
    , modMask            = myModMask
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , layoutHook         = myLayout
    , manageHook         = myManageHook
    , logHook            = myLogHook d
    } `additionalKeysP` myKeys
--
-------------------------------------------------------------- END?? :))
