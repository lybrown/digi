    ; l+ = writing listing
    ; h+ = generate Atari executable headers
    ; f- = don't fill the space between ORGs with $FF
    opt l+h+f-
    icl 'hardware.asm'

    ; Digital sound via Pulse Width Modulation
    ; As reversed engineered from phaeron's side movie demo:
    ; http://www.atariage.com/forums/topic/200051-need-help-with-ide-hardware/

main equ $300
buf equ $400
buftop equ $C000
    org main
init
    sei
    lda #0
    sta IRQEN
    sta NMIEN
    sta DMACTL
    mva #1 GRAFP0
    mva #15 COLPM0
    mva #$50 AUDCTL
    mva #$00 AUDC2
    mva #$00 AUDC3
    mva #$00 AUDC4
    mva #$FF AUDF2
    rts
play
    mva #$AF AUDC1
    mva #$50 AUDCTL
    ldy >buftop
ld
    lda buf
    sta WSYNC
    sta AUDF1
    sta STIMER
    add #$44
    sta HPOSP0
    inc ld+1
    bne ld
    inc ld+2
    cpy ld+2
    bne ld
    mwa #buf ld+1
    rts

quiet
    mva #0 AUDC1
    sta AUDC2
    sta AUDC3
    sta AUDC4
    jmp *

    ini init
>>> my @s = stat "voyage.audf";
>>> my $size = $s[7];
>>> my $max = 1000000;
>>> $size = $max if $size > $max;
>>> my $chunk = 0;
>>> my $buflen = 0xC000 - 0x400;
>>> while ($size > $buflen) {
>>>   print "    org buf\n";
>>>   print "    ins 'voyage.audf',$chunk*[buftop-buf],buftop-buf\n";
>>>   print "    ini play\n";
>>>   ++$chunk;
>>>   $size -= $buflen;
>>> }
    run quiet
