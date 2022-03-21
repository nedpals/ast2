module main

import reporter
import scanner 

fn main() {
		mut rep := &reporter.Collector{
			prefs: reporter.ReporterPreferences{
				warns_are_errors: false
			}
		}

		mut sc := scanner.new_scanner('"\$t(test)"', mut rep)

		println(sc.scan())
		println(sc.scan())
		println(sc.scan())


		println(rep)
}