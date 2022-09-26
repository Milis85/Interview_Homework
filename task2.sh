#!/bin/bash

#nastaveni funkci, instalace prikazu sed a grep
#vytvoreni kopie konf souboru /tmp/foobar

function setup {
sudo dnf -y install sed
sudo dnf -y install grep
cp -f /tmp/foobar /tmp/foobar_orig
}

#funkce opravna, vraceni testovaciho systemu do puvodniho stavu pred spustenim testu

function correction {
cp -f /tmp/foobar_orig /tmp/foobar
}

#$FUNCNAME - promenna prostredi, pro prehlednost vypise, ktery testovaci scenar se provadi
#Foo=1 vysledek nesplnuje podminku vetsi nez 10, predpokladany vysledek podminky FAIL, vysledek testu PASS

function test1 {
echo "starting ----$FUNCNAME----"
echo 'Foo=1' > /tmp/foobar
if foobar_foo_gte_10 | grep FAIL; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#Foo=11 promenna splnuje podminku -ge 10, predpokladny vysledek podminky PASS, vysledek testu PASS

function test2 {
echo "starting ----$FUNCNAME----"
echo 'Foo=11' > /tmp/foobar
if foobar_foo_gte_10 | grep PASS; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#Foo neni ciselna hodnota, nesplnuje podminku -ge 10, predpokladany vysledek podminky FAIL, vysledek testu PASS

function test3 {
echo "starting ----$FUNCNAME----"
echo 'Foo=neconeco' > /tmp/foobar
if foobar_foo_gte_10 | grep FAIL; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#hodnota Foo je zaporne cislo, predpokladany vysledek FAIL,

function test4 {
echo "----starting $FUNCNAME----"
echo 'Foo=   -11' > /tmp/foobar
if foobar_foo_gte_10 | grep FAIL; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#funkce foobar_foo_gte_10 ma nacitat pouze posledni zapis.
#Posledni zapis splnuje podminku -ge 10, pridany mezery v promenne
#vysledek podminky PASS, vysledek testu PASS

function test5 {
echo "starting ----$FUNCNAME----"
echo '# Foo=0' > /tmp/foobar
echo 'Foo=  10' > /tmp/foobar
if foobar_foo_gte_10 | grep PASS; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

# funkce foobar_foo_gte_10 ma nacitat pouze posledni zapis.
#Posledni hodnota zapisu neplnuje podminku
#pridany mezery v promenne
#-ge 10, vysledek podminky FAIL, vysledek testu PASS

function test6 {
echo "starting ----$FUNCNAME----"
echo 'Foo=10' > /tmp/foobar
echo '    Foo             =    0' > /tmp/foobar
if foobar_foo_gte_10 | grep FAIL; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#Hodnota zapisu splnuje podminku -ge 10
#pridany mezery za =
function test7 {
echo "starting ----$FUNCNAME----"
echo 'Foo  = 99' > /tmp/foobar
if foobar_foo_gte_10 | grep PASS; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

# for cyklem ulozim do souboru sekvenci Foo=1 az Foo=20. Funkce by mela nacist posledni hodnotu - 20, splnuje
# podminku Foo -ge 10, predpokladny vysledek podminky PASS, vysledek testu PASS
function testFor {
echo "starting ----$FUNCNAME----"
for i in $(seq 1 20); do
	echo "Foo=$i" >> /tmp/foobar
done
if foobar_foo_gte_10 | grep PASS; then
	echo "----result---- PASS"
else
	echo "----result---- FAIL"
fi
}

#poradi spousteni jednotlivych funkci
setup
source $PWD/task1.sh
foobar_foo_gte_10
test1
test2
test3
test4
test5
test6
test7
testFor
correction
