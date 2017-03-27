package_version = 3.74

source_tarball = iso-codes_$(package_version).orig.tar.xz
source_dir = iso-codes-$(package_version)
source_files = $(source_tarball) $(source_dir)

continents_url = http://dev.maxmind.com/static/csv/codes/country_continent.csv
continents_file = data/iso_3166-1_continents.csv

data_dir = data

json_files = $(wildcard $(source_dir)/data/iso_*.json)
designations = $(subst .json, , $(subst $(source_dir)/data/, , $(json_files)))
csv_files = $(addprefix data/, $(addsuffix .csv, $(designations))) $(continents_file)

dropbox_home = ~/Dropbox\ (Rocketrip)/Rocketrip
target_dir = $(dropbox_home)/Data/Geographical/iso

$(data_dir):
	mkdir -p $@

python-setup:
	pip install -r requirements.txt

source_url_base = http://http.debian.net/debian/pool/main/i/iso-codes/
$(source_tarball):
	curl -LO $(source_url_base)$@
$(source_dir): $(source_tarball)
	tar -xJf $<

csv: $(json_files) $(source_dir) python-setup
	$(MAKE) csv-files
csv-files: $(csv_files)
# $(json_files): $(source_dir) | $(data_dir)
data/%.csv: $(source_dir)/data/%.json scripts/process-iso.py $(source_dir) | $(data_dir)
	python3 $(word 2, $^) $< $@

$(continents_file):
	curl -L '$(continents_url)' | sed 's/--//' > $@

upload: $(target_dir)
$(target_dir): csv
	# rsync --archive --verbose --delete $(addprefix --exclude=, $(source_files)) . "$@"
	rsync --archive --verbose --delete . "$@"


.PHONY: clean python-setup
clean:
	rm -f iso-codes_$(package_version).orig.tar.xz
	rm -rf iso-codes-$(package_version)
	rm -rf data

bootstrap.zip: Makefile README.txt scripts/process-iso.py requirements.txt
	zip $@ $^
