.DEFAULT_GOAL:=json-schema.json
.SHELL:=/usr/bin/zsh

.PHONY: clean
all: gen/actions.vim gen/reqargs.vim gen/optargs.vim json-schema.json

#{{{ txt
txt/actions.txt:
	print 'Generating text dump of actions...'
	mkdir -p txt
	ansible-doc -l |sed '/^$$/,$$ d' >|$@

txt/args.txt: txt/actions.txt
	print 'Generating text dump of all args...'
	mkdir -p txt
	while read -r cmd txt; do ansible-doc -s $$cmd 2>/dev/null; done <$< >|$@
#}}}

#{{{ vim
gen/actions.vim: txt/actions.txt
	print 'Wrote actions to gen/actions.vim'
	mkdir -p gen
	vim --noplugin -u /dev/null -s txt2actions.vim $<

gen/reqargs.vim: txt/args.txt
	print 'Wrote required args to gen/reqargs.vim'
	mkdir -p gen
	vim --noplugin -u /dev/null -s txt2reqargs.vim $<

gen/optargs.vim: txt/args.txt
	print 'Wrote optional args to gen/optargs.vim'
	mkdir -p gen
	vim --noplugin -u /dev/null -s txt2optargs.vim $<
#}}}

#{{{ json-schema.json
xml/args.xml: txt/args.txt
	mkdir -p xml
	sed -i 's/hosts:/hosts/g' $<
	./txt2reqargs.py >$@

json-schema.xml: xml/args.xml args-2-xml-jsonschema.xsl
	saxon-xslt -o $@ $< ./args-2-xml-jsonschema.xsl
	xmlstarlet fo $@ >/tmp/$@
	cp /tmp/$@ $@

json-schema.json: json-schema.xml
	xml2json --strip_newlines --strip_text --pretty -t xml2json -o $@ --strip_text --strip_namespace $<
	cat json-schema.json | jq '."json-schema"' >/tmp/json-schema.json
	cp /tmp/json-schema.json $@
#}}}

clean:
	rm -f json-schema.json json-schema.xml xml/* txt/* gen/*

# vim: fdm=marker
