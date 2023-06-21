! inicijalizacija simulacije
dc x.1, x.9996
dc x.0, x.9998
onkp false, x.1, x.1
onkp false, x.1, x.1
onkp true, x.1, x.1
ondma x.1, x.1
ondma x.1, x.1
ondma x.1, x.1
ondma x.1, x.1
kpreg 1.1, r0, x.1
kpreg 1.1, r1, x.2
kpreg 1.1, r2, x.3
kpreg 1.1, r3, x.4
kpreg 1.1, r4, x.5
kpreg 1.1, r5, x.6
kpreg 1.1, r6, x.7
kpreg 1.1, r7, x.8
kpreg 2.1, r0, x.9
kpreg 2.1, r1, x.a
kpreg 2.1, r2, x.b
kpreg 2.1, r3, x.c
kpreg 2.1, r4, x.d
kpreg 2.1, r5, x.e
kpreg 2.1, r6, x.f
kpreg 2.1, r7, x.10
reg pc, x.4000
reg ivtp, x.4000
reg sp, x.9000
! kraj inicijalizacije

!gl prog
org x.4000

!init iv tabele i svih ulaza 0-5
ldimm x.300,r0
mvrir r0,ivtp

ldimm x.2000,r0
stmem x.300,r0	

ldimm x.1500,r0
stmem x.301,r0

ldimm x.2500,r0
stmem x.302,r0

ldimm x.500,r0
stmem x.303,r0

ldimm x.1000,r0
stmem x.304,r0

ldimm x.3000,r0
stmem x.305,r0

!dodela ulaza uredjajima u entry reg (DMA1.1,KP2.1,DMA1.2,KP1.1,KP1.2,DMA1.4)
ldimm x.0,r0
stmem x.f002,r0

ldimm x.1,r0
stmem x.f202,r0

ldimm x.2,r0
stmem x.f042,r0

ldimm x.3,r0
stmem x.f102,r0

ldimm x.4,r0
stmem x.f142,r0

ldimm x.5,r0
stmem x.f0c2,r0

!A3
ldimm x.9,r0	!size niza +1
ldimm x.5000,r1 	!ptrA
ldimm x.6000,r2	!ptrB
ldimm x.9,r3	!size niza+1

!start kp1.1 i kp2.1
ldimm x.f,r4
stmem x.f100,r4	!start kp1.1
stmem x.f200,r4	!start kp1.2

clr ra		!semafor A
clr rb		!semafor B
!cekanje semafora
ldimm x.1,rc
wait1: and ra,ra,rc
	beql wait1

ldimm x.1,rd
wait2: and rb,rb,rd
	beql wait2

!priprema steka za poziv funkcije za niz A
ldimm x.9996,rf
push rf		!request prvo
ldimm x.8,r0
push r0		!size niza
ldimm x.5000,r1	!ptrA
push r1

!poziv funkcije za niz A
jsr process

pop rf
pop rf
pop rf
clr rf

!priprema steka za poziv funkcije za niz B
ldimm x.9998,rf
push rf		!request prvo
ldimm x.8,r3
push r3		!size niza
ldimm x.6000,r2	!ptrB
push r2
!poziv f-je za niz B
jsr process

pop rf
pop rf
pop rf
clr rf

!init kp1.2
ldimm x.8,r1	!size
ldimm x.5000,r2	!ptrA
ldimm x.4,r0
stmem x.f140,r0	!start kp1.2
ldimm x.1,r3	!semafor

!salje se niz A na kp1.2
loopOut: ldmem x.f141,r4
	and r4,r4,r3
	beql loopOut
	ldrid [r2]x.0,r5
	stmem x.f143,r5
	inc r2
	dec r1
	bneq loopOut
stmem x.f140,r1	!stop kp1.2
	
!init dma1.2 
ldimm x.1,r0
stmem x.f044,r0	!count reg
ldimm x.9999,r0
stmem x.f045,r0	!AdrSource
ldimm x.8e,r0
stmem x.f040,r0	!start dma1.2 u paketskom rezimu

clr r0
!cekamo kraj slanja, dma1.2
ldimm x.1,r1	!test za semafor
waitOut:cmp r1,r0	!da li je semafor 1
	bneq waitOut

!kraj prog
halt

!potprogram process
process:
	push r4	!koristim ga kao bazni reg
	mvrpl r4, sp	! u r4 sp, na steku imamo sada
			! r4, retPC, arr i size i req

	push r2		! koristi se r2
	push r3		! koristi se r3
	push r5
	push r6

	ldrid [r4]x.2,r1	!array
	ldrid [r4]x.3,r2	!size
	ldrid [r4]x.4,r3	!request

	ldrid [r1]x.0,r5	!cuvamo min/max elem u r5

	ldimm x.1,r0	!provera bita operation
	ldrid [r3]x.0,rf	!na adr r3+0 se nalazi polje operation
	cmp r0,rf
	beql max

	loop1:
		inc r1
		dec r2
		beql out
		ldrid [r1]x.0,r6	!ovde cuvam svaki sledeci elem
		cmp r5,r6
		bgrt noviMin	!nadjen je novi min element
		jmp loop1
		noviMin:	mvrrl r5,r6	!u r5 upisujem novi min
		jmp loop1
	max:
		inc r1
		dec r2
		beql out
		ldrid [r1]x.0,r6	!ovde cuvam svaki sledeci elem
		cmp r5,r6
		blss noviMax	!nadjen je novi max
		jmp max
		noviMax:mvrrl r5,r6	!u r5 upisujem novi max
		jmp max
	out:
		inc r3
		stri [r3],r5	!store-ujem rezultat u polje element
		pop r6
		pop r5
		pop r3
		pop r2
		pop r4
		rts

!prek rutina kp1.1
org x.500
dec r0		!brojac niza A
bneq load1
stmem x.f100,r0	!stop kp1.1
ldimm x.1,ra
jmp back1
load1: ldmem x.f103,r6	
	stri [r1],r6
	inc r1
back1:rti

!prek rutina kp2.1
org x.1500
dec r3		!brojac niza A
bneq load2
stmem x.f200,r3	!stop kp1.2
ldimm x.1,rb
jmp back2
load2: ldmem x.f203,r7	
	stri [r2],r7
	inc r2
back2:rti

!prek rutina dma1.2
org x.2500
push r5
clr r5
stmem x.f040,r5
ldimm x.1,r0
pop r5
rti

