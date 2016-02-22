import System.Information.Memory
import System.Taffybar
import System.Taffybar.Battery
import System.Taffybar.Text.MemoryMonitor
import System.Taffybar.Systray
import System.Taffybar.TaffyPager
import System.Taffybar.SimpleClock
import System.Taffybar.Widgets.PollingGraph
import System.Information.CPU

cpuCallback = do
  (_, systemLoad, totalLoad) <- cpuLoad
  return [ totalLoad, systemLoad ]

main = do
    let cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1), (1, 0, 1, 0.5)]
                                    , graphLabel = Nothing
                                    }
        memoryCfg = cpuCfg
        memory = pollingGraphNew memoryCfg 0.7 $ do
                    memInfo <- parseMeminfo
                    return [memoryUsedRatio memInfo]

        clock = textClockNew Nothing "<span fgcolor='orange'>%b %_d %H:%M</span>" 1
        pager = taffyPagerNew defaultPagerConfig
        tray = systrayNew
        cpu = pollingGraphNew cpuCfg 0.7 cpuCallback
        battery = batteryBarNew defaultBatteryConfig 3.0
    defaultTaffybar defaultTaffybarConfig
        { startWidgets = [ pager ]
        , endWidgets = [ tray, clock, cpu, memory, battery ]
        }
