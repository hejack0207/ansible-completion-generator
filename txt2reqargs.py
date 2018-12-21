#!/usr/bin/env python
#encoding=utf-8
from pyparsing import *

def parseActions():
    #chars=alphanums+"/_.:`',-<>()=[]|\"*+\\;%~{}@#?$!&"
    chars = printables+"‘’ "

    nl = Literal("\n")|Literal("\r")
    actionStart = "- name:"
    actionTag = "  action: "
    acomment = Word(chars+" ")
    aname = Word(alphanums+"-_")
    pname = Regex(r"\s{6}[a-zA-Z0-9_\-:]+")("pno").setParseAction(lambda tokens: tokens[0].strip()) \
            ^ Regex(r"\s{6}[a-zA-Z0-9_\-:]+=")("pnr").setParseAction(lambda tokens: tokens[0].strip()[:-1])
    pcomment = Group(Word(chars+" ")+Suppress(nl)\
            +ZeroOrMore(Suppress(Regex(r"\s{31}"))+Word(chars+" ")+Suppress("\n")))
    pcomment.setParseAction(lambda tokens: " ".join(tokens[0].asList()))

    action = Suppress(actionStart)+Suppress(OneOrMore(" "))+acomment("ac")+Suppress(nl)\
            +Suppress(actionTag)+aname("an").setParseAction(lambda tokens: tokens[0].strip())+Suppress(nl) \
            +ZeroOrMore(Group(pname+Suppress(OneOrMore(" "))+Suppress("# ")+pcomment("pc"))("p"),stopOn=actionStart)

    afile = ZeroOrMore(Group(action)("action"))

    with open("./args.txt") as file:
       str1 = file.read()
       afile.leaveWhitespace()
       result = afile.parseString(str1, parseAll=True)
       return result

if __name__ == "__main__":
    r = parseActions()
    print r.asXML('actions')
