.DEFAULT_GOAL:=json-schema.json
.SHELL:=/usr/bin/zsh

.PHONY: clean

#{{{ txt
actions.txt:
	print 'Generating text dump of actions...'
	ansible-doc -l |sed '/^$$/,$$ d' >|actions.txt

args.txt: actions.txt
	print 'Generating text dump of all args...'
	while read -r cmd txt; do ansible-doc -s $$cmd 2>/dev/null; done <actions.txt >|args.txt
#}}}

#{{{ vim
gen/actions.vim: actions.txt
	print 'Wrote actions to ../autoload/actions.vim'
	vim --noplugin -u /dev/null -s txt2actions.vim actions.txt

gen/reqargs.vim: args.txt
	print 'Wrote required args to ../autoload/reqargs.vim'
	vim --noplugin -u /dev/null -s txt2reqargs.vim args.txt

gen/optargs.vim: args.txt
	print 'Wrote optional args to ../autoload/optargs.vim'
	vim --noplugin -u /dev/null -s txt2optargs.vim args.txt

gen/actions.vim: actions.txt
	print 'Wrote ansAction syntax to ../syntax/actions.vim'
	vim --noplugin -u /dev/null -s txt2syn.vim actions.txt
#}}}

#{{{ json-schema.json
args.xml: args.txt
	sed -i 's/hosts:/hosts/g' args.txt
	./txt2reqargs.py >args.xml

json-schema.xml: args.xml args-2-xml-jsonschema.xsl
	saxon-xslt -o $@ args.xml ./args-2-xml-jsonschema.xsl
	xmlstarlet fo $@ >/tmp/$@
	cp /tmp/$@ $@

json-schema.json: json-schema.xml
	xml2json --strip_newlines --strip_text --pretty -t xml2json -o $@ --strip_text --strip_namespace $<
	cat json-schema.json | jq '."json-schema"' >/tmp/json-schema.json
	cp /tmp/json-schema.json json-schema.json
#}}}

clean:
	rm -f json-schema.json json-schema.xml args.xml

# vim: fdm=marker
