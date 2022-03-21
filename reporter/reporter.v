module reporter

import token

pub enum Source {
	scanner
	parser
	checker
	builder
	gen
}

pub enum Kind {
	error
	warning
	notice
}

pub struct Detail {
pub:
	content string
	pos token.Pos
}

pub struct Report {
pub:
	kind      Kind
	message   string
	details   Detail
	file_path string
	pos       token.Pos
	source    Source
	backtrace string
}

pub struct ReporterPreferences {
mut:
	limit              int = 100
	file_path          string = 'internal'
	warns_are_errors   bool
}

pub fn (mut pref ReporterPreferences) set_file_path(new_file_path string) {
	pref.file_path = new_file_path
}

pub interface Reporter {
	count() int
mut:
	prefs   ReporterPreferences
	report(r Report)
}

pub fn (r Reporter) reached_limit() bool {
	return r.count() >= r.prefs.limit
}

pub struct Collector {
mut:
	prefs    ReporterPreferences
	errors   []Report
	warnings []Report
	notices  []Report
}

pub fn (mut c Collector) report(r Report) {
	if r.file_path.len == 0 {
		c.report(Report{
			...r
			file_path: c.prefs.file_path
		})
		return
	}

	match r.kind {
		.error {
			c.errors << r
		}
		.warning {
			if c.prefs.warns_are_errors {
				c.report(Report{
					...r
					kind: .error
				})
				return
			}
			c.warnings << r
		}
		.notice {
			c.notices << r
		}
	}
}

pub fn (c &Collector) count() int {
	return c.errors.len + c.warnings.len + c.notices.len
}