; Disassembly of "p.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $000", ROM0[$0]

RST_00::
    rst $38                                       ; $0000: $ff

Call_000_0001:
    nop                                           ; $0001: $00
    nop                                           ; $0002: $00
    nop                                           ; $0003: $00
    nop                                           ; $0004: $00
    nop                                           ; $0005: $00
    nop                                           ; $0006: $00
    nop                                           ; $0007: $00

RST_08::
    rst $38                                       ; $0008: $ff
    nop                                           ; $0009: $00
    nop                                           ; $000a: $00
    nop                                           ; $000b: $00
    nop                                           ; $000c: $00
    nop                                           ; $000d: $00
    nop                                           ; $000e: $00
    nop                                           ; $000f: $00

RST_10::
    rst $38                                       ; $0010: $ff

Call_000_0011:
    nop                                           ; $0011: $00
    nop                                           ; $0012: $00

Call_000_0013:
    nop                                           ; $0013: $00
    nop                                           ; $0014: $00
    nop                                           ; $0015: $00

Jump_000_0016:
    nop                                           ; $0016: $00
    nop                                           ; $0017: $00

RST_18::
    rst $38                                       ; $0018: $ff
    nop                                           ; $0019: $00
    nop                                           ; $001a: $00
    nop                                           ; $001b: $00
    nop                                           ; $001c: $00
    nop                                           ; $001d: $00
    nop                                           ; $001e: $00
    nop                                           ; $001f: $00

RST_20::
    rst $38                                       ; $0020: $ff
    nop                                           ; $0021: $00
    nop                                           ; $0022: $00
    nop                                           ; $0023: $00
    nop                                           ; $0024: $00
    nop                                           ; $0025: $00
    nop                                           ; $0026: $00
    nop                                           ; $0027: $00

RST_28::
    rst $38                                       ; $0028: $ff
    nop                                           ; $0029: $00
    nop                                           ; $002a: $00
    nop                                           ; $002b: $00
    nop                                           ; $002c: $00
    nop                                           ; $002d: $00
    nop                                           ; $002e: $00
    nop                                           ; $002f: $00

RST_30::
    rst $38                                       ; $0030: $ff
    nop                                           ; $0031: $00
    nop                                           ; $0032: $00
    nop                                           ; $0033: $00
    nop                                           ; $0034: $00
    nop                                           ; $0035: $00
    nop                                           ; $0036: $00
    nop                                           ; $0037: $00

RST_38::
    rst $38                                       ; $0038: $ff
    nop                                           ; $0039: $00
    nop                                           ; $003a: $00
    nop                                           ; $003b: $00

Jump_000_003c:
    nop                                           ; $003c: $00
    nop                                           ; $003d: $00
    nop                                           ; $003e: $00
    nop                                           ; $003f: $00

VBlankInterrupt::
    jp Jump_000_2020                              ; $0040: $c3 $20 $20


    nop                                           ; $0043: $00

Call_000_0044:
    nop                                           ; $0044: $00
    nop                                           ; $0045: $00

Call_000_0046:
    nop                                           ; $0046: $00
    nop                                           ; $0047: $00

LCDCInterrupt::
    rst $38                                       ; $0048: $ff
    nop                                           ; $0049: $00
    nop                                           ; $004a: $00

Jump_000_004b:
    nop                                           ; $004b: $00
    nop                                           ; $004c: $00
    nop                                           ; $004d: $00
    nop                                           ; $004e: $00
    nop                                           ; $004f: $00

TimerOverflowInterrupt::
    jp Jump_000_2302                              ; $0050: $c3 $02 $23


    nop                                           ; $0053: $00
    nop                                           ; $0054: $00
    nop                                           ; $0055: $00
    nop                                           ; $0056: $00
    nop                                           ; $0057: $00

SerialTransferCompleteInterrupt::
    jp Jump_000_2121                              ; $0058: $c3 $21 $21


    nop                                           ; $005b: $00
    nop                                           ; $005c: $00
    nop                                           ; $005d: $00
    nop                                           ; $005e: $00
    nop                                           ; $005f: $00

JoypadTransitionInterrupt::
    reti                                          ; $0060: $d9


Call_000_0061:
Jump_000_0061:
    xor a                                         ; $0061: $af
    ldh [rIF], a                                  ; $0062: $e0 $0f
    ldh a, [rIE]                                  ; $0064: $f0 $ff
    ld b, a                                       ; $0066: $47
    db $cb                                        ; $0067: $cb

    add a                                         ; $0068: $87
    ldh [rIE], a                                  ; $0069: $e0 $ff

jr_000_006b:
    ldh a, [rLY]                                  ; $006b: $f0 $44
    cp $91                                        ; $006d: $fe $91
    jr nz, jr_000_006b                            ; $006f: $20 $fa

    ldh a, [rLCDC]                                ; $0071: $f0 $40

Jump_000_0073:
    and $7f                                       ; $0073: $e6 $7f
    ldh [rLCDC], a                                ; $0075: $e0 $40

Call_000_0077:
    ld a, b                                       ; $0077: $78
    ldh [rIE], a                                  ; $0078: $e0 $ff
    ret                                           ; $007a: $c9


Call_000_007b:
Jump_000_007b:
    ldh a, [rLCDC]                                ; $007b: $f0 $40
    set 7, a                                      ; $007d: $cb $ff
    ldh [rLCDC], a                                ; $007f: $e0 $40
    ret                                           ; $0081: $c9


Call_000_0082:
Jump_000_0082:
    xor a                                         ; $0082: $af
    ld hl, $c300                                  ; $0083: $21 $00 $c3
    ld b, $a0                                     ; $0086: $06 $a0

jr_000_0088:
    ld [hl+], a                                   ; $0088: $22
    dec b                                         ; $0089: $05
    jr nz, jr_000_0088                            ; $008a: $20 $fc

    ret                                           ; $008c: $c9


Call_000_008d:
Jump_000_008d:
    ld a, $a0                                     ; $008d: $3e $a0
    ld hl, $c300                                  ; $008f: $21 $00 $c3
    ld de, $0004                                  ; $0092: $11 $04 $00
    ld b, $28                                     ; $0095: $06 $28

jr_000_0097:
    ld [hl], a                                    ; $0097: $77
    add hl, de                                    ; $0098: $19
    dec b                                         ; $0099: $05
    jr nz, jr_000_0097                            ; $009a: $20 $fb

    ret                                           ; $009c: $c9


Call_000_009d:
    ld [$cee9], a                                 ; $009d: $ea $e9 $ce
    ldh a, [$b8]                                  ; $00a0: $f0 $b8
    push af                                       ; $00a2: $f5
    ld a, [$cee9]                                 ; $00a3: $fa $e9 $ce
    ldh [$b8], a                                  ; $00a6: $e0 $b8
    ld [$2000], a                                 ; $00a8: $ea $00 $20
    call Call_000_00b5                            ; $00ab: $cd $b5 $00
    pop af                                        ; $00ae: $f1
    ldh [$b8], a                                  ; $00af: $e0 $b8
    ld [$2000], a                                 ; $00b1: $ea $00 $20
    ret                                           ; $00b4: $c9


Call_000_00b5:
Jump_000_00b5:
jr_000_00b5:
    ld a, [hl+]                                   ; $00b5: $2a
    ld [de], a                                    ; $00b6: $12
    inc de                                        ; $00b7: $13
    dec bc                                        ; $00b8: $0b
    ld a, c                                       ; $00b9: $79
    or b                                          ; $00ba: $b0
    jr nz, jr_000_00b5                            ; $00bb: $20 $f8

    ret                                           ; $00bd: $c9


    nop                                           ; $00be: $00
    nop                                           ; $00bf: $00
    nop                                           ; $00c0: $00
    nop                                           ; $00c1: $00

Call_000_00c2:
    nop                                           ; $00c2: $00

Call_000_00c3:
    nop                                           ; $00c3: $00
    nop                                           ; $00c4: $00
    nop                                           ; $00c5: $00
    nop                                           ; $00c6: $00
    nop                                           ; $00c7: $00
    nop                                           ; $00c8: $00
    nop                                           ; $00c9: $00
    nop                                           ; $00ca: $00
    nop                                           ; $00cb: $00
    nop                                           ; $00cc: $00

Call_000_00cd:
    nop                                           ; $00cd: $00
    nop                                           ; $00ce: $00
    nop                                           ; $00cf: $00
    nop                                           ; $00d0: $00
    nop                                           ; $00d1: $00

Jump_000_00d2:
    nop                                           ; $00d2: $00
    nop                                           ; $00d3: $00
    nop                                           ; $00d4: $00
    nop                                           ; $00d5: $00
    nop                                           ; $00d6: $00
    nop                                           ; $00d7: $00
    nop                                           ; $00d8: $00
    nop                                           ; $00d9: $00
    nop                                           ; $00da: $00
    nop                                           ; $00db: $00
    nop                                           ; $00dc: $00
    nop                                           ; $00dd: $00
    nop                                           ; $00de: $00
    nop                                           ; $00df: $00
    nop                                           ; $00e0: $00
    nop                                           ; $00e1: $00
    nop                                           ; $00e2: $00
    nop                                           ; $00e3: $00
    nop                                           ; $00e4: $00
    nop                                           ; $00e5: $00
    nop                                           ; $00e6: $00
    nop                                           ; $00e7: $00
    nop                                           ; $00e8: $00
    nop                                           ; $00e9: $00
    nop                                           ; $00ea: $00

Jump_000_00eb:
    nop                                           ; $00eb: $00
    nop                                           ; $00ec: $00

Jump_000_00ed:
    nop                                           ; $00ed: $00
    nop                                           ; $00ee: $00
    nop                                           ; $00ef: $00
    nop                                           ; $00f0: $00
    nop                                           ; $00f1: $00

Jump_000_00f2:
    nop                                           ; $00f2: $00
    nop                                           ; $00f3: $00
    nop                                           ; $00f4: $00
    nop                                           ; $00f5: $00
    nop                                           ; $00f6: $00
    nop                                           ; $00f7: $00
    nop                                           ; $00f8: $00
    nop                                           ; $00f9: $00
    nop                                           ; $00fa: $00
    nop                                           ; $00fb: $00
    nop                                           ; $00fc: $00
    nop                                           ; $00fd: $00

Call_000_00fe:
Jump_000_00fe:
    nop                                           ; $00fe: $00

Call_000_00ff:
Jump_000_00ff:
    nop                                           ; $00ff: $00

Boot::
    nop                                           ; $0100: $00

Jump_000_0101:
    jp Jump_000_0150                              ; $0101: $c3 $50 $01


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db "POKEMON RED", $00, $00, $00, $00, $00

HeaderNewLicenseeCode::
    db $30, $31

HeaderSGBFlag::
    db $03

HeaderCartridgeType::
    db $1b

HeaderROMSize::
    db $05

HeaderRAMSize::
    db $03

HeaderDestinationCode::
    db $01

HeaderOldLicenseeCode::
    db $33

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $18

HeaderGlobalChecksum::
    db $7a, $fc

Jump_000_0150:
    cp $11                                        ; $0150: $fe $11
    jr z, jr_000_0157                             ; $0152: $28 $03

    xor a                                         ; $0154: $af
    jr jr_000_0159                                ; $0155: $18 $02

jr_000_0157:
    ld a, $00                                     ; $0157: $3e $00

Jump_000_0159:
jr_000_0159:
    ld [$cf1f], a                                 ; $0159: $ea $1f $cf
    jp Jump_000_1f50                              ; $015c: $c3 $50 $1f


Call_000_015f:
    ld a, $20                                     ; $015f: $3e $20
    ld c, $00                                     ; $0161: $0e $00
    ldh [rP1], a                                  ; $0163: $e0 $00
    ldh a, [rP1]                                  ; $0165: $f0 $00
    ldh a, [rP1]                                  ; $0167: $f0 $00
    ldh a, [rP1]                                  ; $0169: $f0 $00
    ldh a, [rP1]                                  ; $016b: $f0 $00
    ldh a, [rP1]                                  ; $016d: $f0 $00
    ldh a, [rP1]                                  ; $016f: $f0 $00
    cpl                                           ; $0171: $2f
    and $0f                                       ; $0172: $e6 $0f
    swap a                                        ; $0174: $cb $37
    ld b, a                                       ; $0176: $47
    ld a, $10                                     ; $0177: $3e $10

Call_000_0179:
    ldh [rP1], a                                  ; $0179: $e0 $00
    ldh a, [rP1]                                  ; $017b: $f0 $00
    ldh a, [rP1]                                  ; $017d: $f0 $00
    ldh a, [rP1]                                  ; $017f: $f0 $00
    ldh a, [rP1]                                  ; $0181: $f0 $00
    ldh a, [rP1]                                  ; $0183: $f0 $00
    ldh a, [rP1]                                  ; $0185: $f0 $00
    ldh a, [rP1]                                  ; $0187: $f0 $00
    ldh a, [rP1]                                  ; $0189: $f0 $00
    ldh a, [rP1]                                  ; $018b: $f0 $00
    ldh a, [rP1]                                  ; $018d: $f0 $00
    cpl                                           ; $018f: $2f
    and $0f                                       ; $0190: $e6 $0f
    or b                                          ; $0192: $b0
    ldh [$f8], a                                  ; $0193: $e0 $f8
    ld a, $30                                     ; $0195: $3e $30
    ldh [rP1], a                                  ; $0197: $e0 $00
    ret                                           ; $0199: $c9


Call_000_019a:
Jump_000_019a:
    ldh a, [$b8]                                  ; $019a: $f0 $b8
    push af                                       ; $019c: $f5
    ld a, $03                                     ; $019d: $3e $03
    ldh [$b8], a                                  ; $019f: $e0 $b8
    ld [$2000], a                                 ; $01a1: $ea $00 $20
    call $4000                                    ; $01a4: $cd $00 $40
    pop af                                        ; $01a7: $f1
    ldh [$b8], a                                  ; $01a8: $e0 $b8
    ld [$2000], a                                 ; $01aa: $ea $00 $20
    ret                                           ; $01ad: $c9


    and c                                         ; $01ae: $a1
    ld b, d                                       ; $01af: $42

Call_000_01b0:
    ld d, a                                       ; $01b0: $57
    ld b, e                                       ; $01b1: $43

Call_000_01b2:
    ld d, h                                       ; $01b2: $54
    ld b, l                                       ; $01b3: $45
    ld c, [hl]                                    ; $01b4: $4e
    ld b, a                                       ; $01b5: $47
    nop                                           ; $01b6: $00
    ld b, b                                       ; $01b7: $40
    sbc b                                         ; $01b8: $98
    ld c, c                                       ; $01b9: $49
    nop                                           ; $01ba: $00
    ld b, b                                       ; $01bb: $40
    and a                                         ; $01bc: $a7
    ld c, e                                       ; $01bd: $4b
    nop                                           ; $01be: $00
    ld b, b                                       ; $01bf: $40
    ld e, $49                                     ; $01c0: $1e $49

Call_000_01c2:
    and h                                         ; $01c2: $a4
    ld c, c                                       ; $01c3: $49
    and h                                         ; $01c4: $a4
    ld c, c                                       ; $01c5: $49
    jp VBlankInterrupt                            ; $01c6: $c3 $40 $00


    ld b, b                                       ; $01c9: $40
    and $41                                       ; $01ca: $e6 $41
    sub b                                         ; $01cc: $90
    ld b, e                                       ; $01cd: $43
    add c                                         ; $01ce: $81
    ld b, l                                       ; $01cf: $45
    nop                                           ; $01d0: $00
    ld b, b                                       ; $01d1: $40
    nop                                           ; $01d2: $00
    ld b, b                                       ; $01d3: $40
    dec l                                         ; $01d4: $2d
    ld b, c                                       ; $01d5: $41
    add [hl]                                      ; $01d6: $86
    ld b, [hl]                                    ; $01d7: $46
    call nc, $be42                                ; $01d8: $d4 $42 $be
    ld b, h                                       ; $01db: $44
    ld l, l                                       ; $01dc: $6d
    ld b, [hl]                                    ; $01dd: $46
    inc c                                         ; $01de: $0c
    ld c, b                                       ; $01df: $48
    sbc c                                         ; $01e0: $99
    ld c, c                                       ; $01e1: $49
    inc l                                         ; $01e2: $2c
    ld c, c                                       ; $01e3: $49
    jp c, Jump_000_204a                           ; $01e4: $da $4a $20

    ld c, e                                       ; $01e7: $4b
    jr c, jr_000_0236                             ; $01e8: $38 $4c

    ld a, b                                       ; $01ea: $78
    ld c, [hl]                                    ; $01eb: $4e
    pop af                                        ; $01ec: $f1

Jump_000_01ed:
    ld b, b                                       ; $01ed: $40
    rst $38                                       ; $01ee: $ff
    ld c, a                                       ; $01ef: $4f
    nop                                           ; $01f0: $00
    ld b, b                                       ; $01f1: $40
    ccf                                           ; $01f2: $3f
    ld b, e                                       ; $01f3: $43
    add d                                         ; $01f4: $82
    ld b, [hl]                                    ; $01f5: $46
    sbc e                                         ; $01f6: $9b
    ld b, a                                       ; $01f7: $47
    ld e, h                                       ; $01f8: $5c
    ld b, c                                       ; $01f9: $41
    and h                                         ; $01fa: $a4
    ld b, b                                       ; $01fb: $40
    inc [hl]                                      ; $01fc: $34
    ld e, e                                       ; $01fd: $5b
    ld [bc], a                                    ; $01fe: $02
    ld c, e                                       ; $01ff: $4b

Jump_000_0200:
    ld d, c                                       ; $0200: $51
    ld b, d                                       ; $0201: $42
    ld h, d                                       ; $0202: $62
    ld d, h                                       ; $0203: $54
    ld b, b                                       ; $0204: $40
    ld d, l                                       ; $0205: $55
    ld a, l                                       ; $0206: $7d
    ld d, l                                       ; $0207: $55

Jump_000_0208:
    db $e4                                        ; $0208: $e4
    ld c, b                                       ; $0209: $48
    and a                                         ; $020a: $a7
    ld e, [hl]                                    ; $020b: $5e
    ld l, a                                       ; $020c: $6f
    ld d, l                                       ; $020d: $55
    db $e4                                        ; $020e: $e4
    ld e, [hl]                                    ; $020f: $5e
    cp h                                          ; $0210: $bc
    ld d, l                                       ; $0211: $55
    ld b, h                                       ; $0212: $44
    ld d, [hl]                                    ; $0213: $56
    ld bc, $eb51                                  ; $0214: $01 $51 $eb
    ld b, b                                       ; $0217: $40
    dec bc                                        ; $0218: $0b
    ld b, e                                       ; $0219: $43
    ld a, e                                       ; $021a: $7b
    ld b, e                                       ; $021b: $43
    rst $20                                       ; $021c: $e7
    ld d, l                                       ; $021d: $55
    jp hl                                         ; $021e: $e9


    ld c, h                                       ; $021f: $4c
    inc a                                         ; $0220: $3c

Call_000_0221:
    ld d, [hl]                                    ; $0221: $56
    ld a, b                                       ; $0222: $78
    ld b, l                                       ; $0223: $45
    cp e                                          ; $0224: $bb
    ld e, c                                       ; $0225: $59
    add hl, sp                                    ; $0226: $39

Call_000_0227:
    ld e, d                                       ; $0227: $5a
    cp $5c                                        ; $0228: $fe $5c
    ld a, c                                       ; $022a: $79
    ld d, [hl]                                    ; $022b: $56
    ld [$3656], a                                 ; $022c: $ea $56 $36
    ld b, [hl]                                    ; $022f: $46
    and h                                         ; $0230: $a4
    ld b, [hl]                                    ; $0231: $46
    jr nc, jr_000_028b                            ; $0232: $30 $57

    add b                                         ; $0234: $80
    ld c, b                                       ; $0235: $48

jr_000_0236:
    jp nz, $7952                                  ; $0236: $c2 $52 $79

    ld d, [hl]                                    ; $0239: $56
    ld a, [hl+]                                   ; $023a: $2a
    ld e, a                                       ; $023b: $5f
    sub c                                         ; $023c: $91
    ld d, [hl]                                    ; $023d: $56
    ld b, e                                       ; $023e: $43
    ld h, d                                       ; $023f: $62
    inc [hl]                                      ; $0240: $34
    ld h, b                                       ; $0241: $60
    rst $10                                       ; $0242: $d7
    ld d, [hl]                                    ; $0243: $56
    rst $10                                       ; $0244: $d7
    ld d, [hl]                                    ; $0245: $56
    rst $30                                       ; $0246: $f7
    ld h, b                                       ; $0247: $60
    inc d                                         ; $0248: $14
    ld d, a                                       ; $0249: $57
    ld d, c                                       ; $024a: $51
    ld d, a                                       ; $024b: $57
    cp [hl]                                       ; $024c: $be
    ld h, c                                       ; $024d: $61
    add b                                         ; $024e: $80
    ld h, d                                       ; $024f: $62
    xor l                                         ; $0250: $ad
    ld d, e                                       ; $0251: $53
    ret nc                                        ; $0252: $d0

    ld b, h                                       ; $0253: $44
    cp l                                          ; $0254: $bd
    ld h, d                                       ; $0255: $62
    rst $38                                       ; $0256: $ff
    ld d, e                                       ; $0257: $53
    or c                                          ; $0258: $b1
    ld h, l                                       ; $0259: $65
    ld b, a                                       ; $025a: $47
    ld d, h                                       ; $025b: $54
    rst $30                                       ; $025c: $f7
    ld d, h                                       ; $025d: $54
    ld h, c                                       ; $025e: $61
    ld h, a                                       ; $025f: $67
    ld a, d                                       ; $0260: $7a
    ld c, c                                       ; $0261: $49
    ld h, h                                       ; $0262: $64

Call_000_0263:
    ld e, e                                       ; $0263: $5b
    call z, Call_000_1149                         ; $0264: $cc $49 $11
    ld c, d                                       ; $0267: $4a
    di                                            ; $0268: $f3
    ld e, d                                       ; $0269: $5a
    ld c, c                                       ; $026a: $49
    ld e, e                                       ; $026b: $5b
    ld e, c                                       ; $026c: $59

Call_000_026d:
    ld d, d                                       ; $026d: $52
    sub e                                         ; $026e: $93
    ld d, e                                       ; $026f: $53
    ld h, $49                                     ; $0270: $26 $49
    ld [hl+], a                                   ; $0272: $22
    ld d, [hl]                                    ; $0273: $56
    and d                                         ; $0274: $a2
    ld d, [hl]                                    ; $0275: $56
    and a                                         ; $0276: $a7
    ld d, a                                       ; $0277: $57
    adc c                                         ; $0278: $89
    ld e, b                                       ; $0279: $58
    ld l, d                                       ; $027a: $6a
    ld e, c                                       ; $027b: $59
    ccf                                           ; $027c: $3f
    ld e, e                                       ; $027d: $5b
    ld c, c                                       ; $027e: $49
    ld e, l                                       ; $027f: $5d
    and d                                         ; $0280: $a2
    ld h, d                                       ; $0281: $62
    and d                                         ; $0282: $a2
    ld h, d                                       ; $0283: $62
    and d                                         ; $0284: $a2
    ld h, d                                       ; $0285: $62
    ld a, [c]                                     ; $0286: $f2
    ld e, c                                       ; $0287: $59
    and d                                         ; $0288: $a2
    ld h, d                                       ; $0289: $62
    and d                                         ; $028a: $a2

jr_000_028b:
    ld h, d                                       ; $028b: $62
    and d                                         ; $028c: $a2
    ld h, d                                       ; $028d: $62
    and d                                         ; $028e: $a2
    ld h, d                                       ; $028f: $62
    and d                                         ; $0290: $a2
    ld h, d                                       ; $0291: $62
    and d                                         ; $0292: $a2
    ld h, d                                       ; $0293: $62
    and d                                         ; $0294: $a2
    ld h, d                                       ; $0295: $62
    and d                                         ; $0296: $a2
    ld h, d                                       ; $0297: $62
    and d                                         ; $0298: $a2
    ld h, d                                       ; $0299: $62
    sub d                                         ; $029a: $92
    ld h, h                                       ; $029b: $64
    ld a, [de]                                    ; $029c: $1a
    ld e, a                                       ; $029d: $5f
    ld d, e                                       ; $029e: $53
    ld e, a                                       ; $029f: $5f
    ld a, $5f                                     ; $02a0: $3e $5f
    ld a, d                                       ; $02a2: $7a
    ld c, a                                       ; $02a3: $4f
    jp hl                                         ; $02a4: $e9


    ld h, b                                       ; $02a5: $60
    add hl, de                                    ; $02a6: $19

Jump_000_02a7:
    ld b, d                                       ; $02a7: $42
    ld c, d                                       ; $02a8: $4a
    ld b, e                                       ; $02a9: $43
    ret                                           ; $02aa: $c9


    ld b, e                                       ; $02ab: $43
    db $f4                                        ; $02ac: $f4
    ld b, l                                       ; $02ad: $45
    adc b                                         ; $02ae: $88
    ld b, [hl]                                    ; $02af: $46

Call_000_02b0:
Jump_000_02b0:
    ld l, $47                                     ; $02b0: $2e $47
    add h                                         ; $02b2: $84
    ld b, a                                       ; $02b3: $47
    ld e, a                                       ; $02b4: $5f
    ld c, b                                       ; $02b5: $48
    ld sp, $ac5d                                  ; $02b6: $31 $5d $ac
    ld c, b                                       ; $02b9: $48
    cp $48                                        ; $02ba: $fe $48
    xor a                                         ; $02bc: $af

Jump_000_02bd:
    ld c, e                                       ; $02bd: $4b
    ld e, h                                       ; $02be: $5c

Call_000_02bf:
    ld d, b                                       ; $02bf: $50
    db $e3                                        ; $02c0: $e3
    ld d, b                                       ; $02c1: $50
    ld b, h                                       ; $02c2: $44
    ld d, c                                       ; $02c3: $51
    ld bc, $5c52                                  ; $02c4: $01 $52 $5c
    ld d, d                                       ; $02c7: $52
    push bc                                       ; $02c8: $c5
    ld c, b                                       ; $02c9: $48

Call_000_02ca:
    jr nz, jr_000_0310                            ; $02ca: $20 $44

    and $44                                       ; $02cc: $e6 $44
    ret nz                                        ; $02ce: $c0

    ld b, [hl]                                    ; $02cf: $46
    ld [$2647], a                                 ; $02d0: $ea $47 $26
    ld c, c                                       ; $02d3: $49
    db $e3                                        ; $02d4: $e3
    ld c, d                                       ; $02d5: $4a
    ld sp, hl                                     ; $02d6: $f9
    ld c, h                                       ; $02d7: $4c
    sbc a                                         ; $02d8: $9f
    ld e, b                                       ; $02d9: $58
    rla                                           ; $02da: $17
    ld c, c                                       ; $02db: $49
    and l                                         ; $02dc: $a5
    ld e, c                                       ; $02dd: $59
    ld a, a                                       ; $02de: $7f
    ld e, l                                       ; $02df: $5d
    ld d, l                                       ; $02e0: $55
    ld d, b                                       ; $02e1: $50
    and b                                         ; $02e2: $a0
    ld d, b                                       ; $02e3: $50
    ld a, [c]                                     ; $02e4: $f2
    ld d, b                                       ; $02e5: $50
    ld a, [bc]                                    ; $02e6: $0a
    ld d, d                                       ; $02e7: $52
    ld a, d                                       ; $02e8: $7a
    ld d, h                                       ; $02e9: $54
    inc e                                         ; $02ea: $1c
    ld d, a                                       ; $02eb: $57
    add hl, bc                                    ; $02ec: $09
    ld h, e                                       ; $02ed: $63
    ld b, l                                       ; $02ee: $45
    ld h, h                                       ; $02ef: $64
    add c                                         ; $02f0: $81
    ld h, l                                       ; $02f1: $65
    adc l                                         ; $02f2: $8d
    ld h, a                                       ; $02f3: $67
    ld h, h                                       ; $02f4: $64
    ld h, b                                       ; $02f5: $60
    ld [hl], b                                    ; $02f6: $70
    ld h, c                                       ; $02f7: $61
    and e                                         ; $02f8: $a3
    ld b, d                                       ; $02f9: $42
    add e                                         ; $02fa: $83
    ld d, a                                       ; $02fb: $57

Call_000_02fc:
    jp nz, $575b                                  ; $02fc: $c2 $5b $57

Jump_000_02ff:
    ld e, h                                       ; $02ff: $5c
    cp l                                          ; $0300: $bd
    ld e, h                                       ; $0301: $5c
    ld h, a                                       ; $0302: $67

Call_000_0303:
    ld e, l                                       ; $0303: $5d
    ld h, d                                       ; $0304: $62
    ld e, [hl]                                    ; $0305: $5e
    or h                                          ; $0306: $b4
    ld e, [hl]                                    ; $0307: $5e
    or h                                          ; $0308: $b4
    ld e, [hl]                                    ; $0309: $5e
    ld d, h                                       ; $030a: $54
    ld e, h                                       ; $030b: $5c
    ld sp, hl                                     ; $030c: $f9
    ld e, [hl]                                    ; $030d: $5e
    ld e, l                                       ; $030e: $5d

Jump_000_030f:
    ld c, h                                       ; $030f: $4c

jr_000_0310:
    ld c, c                                       ; $0310: $49
    ld c, l                                       ; $0311: $4d
    ld sp, hl                                     ; $0312: $f9
    ld c, a                                       ; $0313: $4f
    call nc, $f15d                                ; $0314: $d4 $5d $f1
    ld d, e                                       ; $0317: $53
    ld [hl], $54                                  ; $0318: $36 $54
    dec e                                         ; $031a: $1d
    ld d, l                                       ; $031b: $55
    inc sp                                        ; $031c: $33
    ld e, [hl]                                    ; $031d: $5e
    push af                                       ; $031e: $f5
    ld d, l                                       ; $031f: $55
    dec a                                         ; $0320: $3d
    ld d, [hl]                                    ; $0321: $56
    or c                                          ; $0322: $b1
    ld d, [hl]                                    ; $0323: $56
    cp $57                                        ; $0324: $fe $57
    rst $28                                       ; $0326: $ef
    ld h, l                                       ; $0327: $65
    ld [hl], e                                    ; $0328: $73
    ld h, h                                       ; $0329: $64
    ld l, c                                       ; $032a: $69
    ld e, b                                       ; $032b: $58
    ld l, b                                       ; $032c: $68
    ld e, c                                       ; $032d: $59
    db $dd                                        ; $032e: $dd
    ld b, a                                       ; $032f: $47
    ld a, d                                       ; $0330: $7a
    ld h, [hl]                                    ; $0331: $66
    sub h                                         ; $0332: $94
    ld d, a                                       ; $0333: $57
    ld d, e                                       ; $0334: $53
    ld d, l                                       ; $0335: $55
    dec bc                                        ; $0336: $0b
    ld e, h                                       ; $0337: $5c
    ld h, d                                       ; $0338: $62
    ld e, a                                       ; $0339: $5f
    ld [hl], h                                    ; $033a: $74
    ld c, c                                       ; $033b: $49
    cp [hl]                                       ; $033c: $be

Call_000_033d:
    ld c, e                                       ; $033d: $4b

Jump_000_033e:
    dec de                                        ; $033e: $1b

Call_000_033f:
    ld c, [hl]                                    ; $033f: $4e

Call_000_0340:
    add hl, de                                    ; $0340: $19
    ld d, d                                       ; $0341: $52
    ld d, c                                       ; $0342: $51
    ld d, h                                       ; $0343: $54
    inc b                                         ; $0344: $04
    ld d, a                                       ; $0345: $57
    inc b                                         ; $0346: $04
    ld d, a                                       ; $0347: $57
    inc b                                         ; $0348: $04
    ld d, a                                       ; $0349: $57
    inc b                                         ; $034a: $04
    ld d, a                                       ; $034b: $57
    push hl                                       ; $034c: $e5
    ld e, h                                       ; $034d: $5c
    ld c, a                                       ; $034e: $4f
    ld e, a                                       ; $034f: $5f
    inc b                                         ; $0350: $04
    ld e, l                                       ; $0351: $5d
    jr nc, jr_000_03b3                            ; $0352: $30 $5f

    and d                                         ; $0354: $a2
    ld h, c                                       ; $0355: $61
    ld e, b                                       ; $0356: $58
    ld e, e                                       ; $0357: $5b
    ld hl, sp+$64                                 ; $0358: $f8 $64
    rst $08                                       ; $035a: $cf

Call_000_035b:
    ld e, a                                       ; $035b: $5f
    push hl                                       ; $035c: $e5
    ld h, c                                       ; $035d: $61
    or b                                          ; $035e: $b0
    ld h, e                                       ; $035f: $63

Call_000_0360:
    ld e, a                                       ; $0360: $5f
    ld e, b                                       ; $0361: $58
    sbc a                                         ; $0362: $9f

Call_000_0363:
    ld e, c                                       ; $0363: $59
    xor b                                         ; $0364: $a8
    ld h, c                                       ; $0365: $61

Jump_000_0366:
    and [hl]                                      ; $0366: $a6
    ld e, e                                       ; $0367: $5b
    pop hl                                        ; $0368: $e1
    ld e, h                                       ; $0369: $5c
    ld a, [bc]                                    ; $036a: $0a
    ld h, e                                       ; $036b: $63
    ld e, $5d                                     ; $036c: $1e $5d
    ld l, c                                       ; $036e: $69
    ld e, l                                       ; $036f: $5d
    or h                                          ; $0370: $b4
    ld e, l                                       ; $0371: $5d
    rst $38                                       ; $0372: $ff
    ld e, l                                       ; $0373: $5d
    db $e4                                        ; $0374: $e4
    ld e, [hl]                                    ; $0375: $5e
    ld c, b                                       ; $0376: $48
    ld c, l                                       ; $0377: $4d
    add hl, bc                                    ; $0378: $09
    ld e, d                                       ; $0379: $5a
    ld b, l                                       ; $037a: $45
    ld c, [hl]                                    ; $037b: $4e
    or c                                          ; $037c: $b1
    ld d, [hl]                                    ; $037d: $56
    rst $18                                       ; $037e: $df
    ld e, a                                       ; $037f: $5f
    and e                                         ; $0380: $a3
    ld d, a                                       ; $0381: $57
    dec l                                         ; $0382: $2d
    ld h, c                                       ; $0383: $61
    xor $60                                       ; $0384: $ee $60
    or h                                          ; $0386: $b4
    ld d, a                                       ; $0387: $57
    push hl                                       ; $0388: $e5
    ld e, h                                       ; $0389: $5c
    push hl                                       ; $038a: $e5
    ld e, h                                       ; $038b: $5c
    inc b                                         ; $038c: $04
    ld a, l                                       ; $038d: $7d
    ld [hl], c                                    ; $038e: $71
    ld a, l                                       ; $038f: $7d
    push hl                                       ; $0390: $e5
    ld e, h                                       ; $0391: $5c
    push hl                                       ; $0392: $e5
    ld e, h                                       ; $0393: $5c
    push hl                                       ; $0394: $e5
    ld e, h                                       ; $0395: $5c
    push hl                                       ; $0396: $e5
    ld e, h                                       ; $0397: $5c
    or c                                          ; $0398: $b1
    ld h, c                                       ; $0399: $61
    inc c                                         ; $039a: $0c
    ld h, e                                       ; $039b: $63
    ld h, e                                       ; $039c: $63
    ld h, h                                       ; $039d: $64

Call_000_039e:
    ld b, $1c                                     ; $039e: $06 $1c
    ld hl, $487f                                  ; $03a0: $21 $7f $48
    jp Jump_000_35f3                              ; $03a3: $c3 $f3 $35


Jump_000_03a6:
    ld a, $ff                                     ; $03a6: $3e $ff
    ld [$cd6b], a                                 ; $03a8: $ea $6b $cd
    call Call_000_1241                            ; $03ab: $cd $41 $12
    ld b, $03                                     ; $03ae: $06 $03

Call_000_03b0:
Jump_000_03b0:
    ld hl, $4335                                  ; $03b0: $21 $35 $43

jr_000_03b3:
    call Call_000_35f3                            ; $03b3: $cd $f3 $35
    ld hl, $d731                                  ; $03b6: $21 $31 $d7
    bit 0, [hl]                                   ; $03b9: $cb $46
    jr z, jr_000_03c2                             ; $03bb: $28 $05

    ld a, $03                                     ; $03bd: $3e $03
    ld [$d141], a                                 ; $03bf: $ea $41 $d1

jr_000_03c2:
    ld hl, $d733                                  ; $03c2: $21 $33 $d7
    bit 5, [hl]                                   ; $03c5: $cb $6e

Jump_000_03c7:
    res 5, [hl]                                   ; $03c7: $cb $ae
    call z, Call_000_12e7                         ; $03c9: $cc $e7 $12
    call nz, Call_000_091f                        ; $03cc: $c4 $1f $09
    ld hl, $d737                                  ; $03cf: $21 $37 $d7
    ld a, [hl]                                    ; $03d2: $7e
    and $18                                       ; $03d3: $e6 $18
    jr z, jr_000_03e4                             ; $03d5: $28 $0d

    res 3, [hl]                                   ; $03d7: $cb $9e
    ld b, $1c                                     ; $03d9: $06 $1c
    ld hl, $4511                                  ; $03db: $21 $11 $45
    call Call_000_35f3                            ; $03de: $cd $f3 $35

Jump_000_03e1:
    call Call_000_2425                            ; $03e1: $cd $25 $24

jr_000_03e4:
    ld b, $03                                     ; $03e4: $06 $03
    ld hl, $438b                                  ; $03e6: $21 $8b $43
    call Call_000_35f3                            ; $03e9: $cd $f3 $35

Jump_000_03ec:
    ld hl, $d732                                  ; $03ec: $21 $32 $d7
    res 5, [hl]                                   ; $03ef: $cb $ae
    call Call_000_2425                            ; $03f1: $cd $25 $24
    ld hl, $d12b                                  ; $03f4: $21 $2b $d1
    set 5, [hl]                                   ; $03f7: $cb $ee
    set 6, [hl]                                   ; $03f9: $cb $f6
    xor a                                         ; $03fb: $af
    ld [$cd6b], a                                 ; $03fc: $ea $6b $cd

Jump_000_03ff:
    call Call_000_20ab                            ; $03ff: $cd $ab $20

Call_000_0402:
Jump_000_0402:
    call Call_000_20ab                            ; $0402: $cd $ab $20
    call Call_000_20b6                            ; $0405: $cd $b6 $20
    ld a, [$d73b]                                 ; $0408: $fa $3b $d7
    bit 6, a                                      ; $040b: $cb $77
    call nz, Call_000_039e                        ; $040d: $c4 $9e $03
    ld a, [$cfca]                                 ; $0410: $fa $ca $cf
    and a                                         ; $0413: $a7
    jp nz, Jump_000_05b5                          ; $0414: $c2 $b5 $05

    call Call_000_0f4d                            ; $0417: $cd $4d $0f
    ld b, $07                                     ; $041a: $06 $07
    ld hl, $698b                                  ; $041c: $21 $8b $69
    call Call_000_35f3                            ; $041f: $cd $f3 $35
    ld a, [$da4b]                                 ; $0422: $fa $4b $da
    and a                                         ; $0425: $a7
    jp nz, Jump_000_073c                          ; $0426: $c2 $3c $07

    ld hl, $d732                                  ; $0429: $21 $32 $d7
    bit 3, [hl]                                   ; $042c: $cb $5e
    res 3, [hl]                                   ; $042e: $cb $9e
    jp nz, Jump_000_073c                          ; $0430: $c2 $3c $07

    ld a, [$d737]                                 ; $0433: $fa $37 $d7
    and $18                                       ; $0436: $e6 $18

Jump_000_0438:
    jp nz, Jump_000_0965                          ; $0438: $c2 $65 $09

    ld a, [$d05e]                                 ; $043b: $fa $5e $d0
    and a                                         ; $043e: $a7
    jp nz, Jump_000_062c                          ; $043f: $c2 $2c $06

    ld a, [$d735]                                 ; $0442: $fa $35 $d7

Call_000_0445:
    bit 7, a                                      ; $0445: $cb $7f
    jr z, jr_000_044d                             ; $0447: $28 $04

    ldh a, [$b4]                                  ; $0449: $f0 $b4
    jr jr_000_044f                                ; $044b: $18 $02

Call_000_044d:
jr_000_044d:
    ldh a, [$b3]                                  ; $044d: $f0 $b3

jr_000_044f:
    bit 3, a                                      ; $044f: $cb $5f
    jr z, jr_000_0459                             ; $0451: $28 $06

    xor a                                         ; $0453: $af
    ldh [$8c], a                                  ; $0454: $e0 $8c

Jump_000_0456:
    jp Jump_000_047d                              ; $0456: $c3 $7d $04


jr_000_0459:
    bit 0, a                                      ; $0459: $cb $47
    jp z, Jump_000_04eb                           ; $045b: $ca $eb $04

    ld a, [$d735]                                 ; $045e: $fa $35 $d7
    bit 2, a                                      ; $0461: $cb $57
    jp nz, Jump_000_04cd                          ; $0463: $c2 $cd $04

    call Call_000_311a                            ; $0466: $cd $1a $31
    jr nz, jr_000_04c3                            ; $0469: $20 $58

    call Call_000_3ed2                            ; $046b: $cd $d2 $3e
    ldh a, [$eb]                                  ; $046e: $f0 $eb
    and a                                         ; $0470: $a7
    jp z, Jump_000_03ff                           ; $0471: $ca $ff $03

    call Call_000_0b23                            ; $0474: $cd $23 $0b
    ldh a, [$8c]                                  ; $0477: $f0 $8c
    and a                                         ; $0479: $a7
    jp z, Jump_000_03ff                           ; $047a: $ca $ff $03

Jump_000_047d:
    ld a, $35                                     ; $047d: $3e $35
    call Call_000_3e8a                            ; $047f: $cd $8a $3e

Jump_000_0482:
    call Call_000_2425                            ; $0482: $cd $25 $24
    ld a, [$cd60]                                 ; $0485: $fa $60 $cd
    bit 2, a                                      ; $0488: $cb $57
    jr nz, jr_000_04c3                            ; $048a: $20 $37

    bit 0, a                                      ; $048c: $cb $47
    jr nz, jr_000_04c3                            ; $048e: $20 $33

Jump_000_0490:
    ld a, [$c45c]                                 ; $0490: $fa $5c $c4
    ld [$cf13], a                                 ; $0493: $ea $13 $cf
    call Call_000_291c                            ; $0496: $cd $1c $29
    ld a, [$cc47]                                 ; $0499: $fa $47 $cc
    and a                                         ; $049c: $a7
    jr z, jr_000_04c3                             ; $049d: $28 $24

    dec a                                         ; $049f: $3d
    ld a, $00                                     ; $04a0: $3e $00
    ld [$cc47], a                                 ; $04a2: $ea $47 $cc
    jr z, jr_000_04c0                             ; $04a5: $28 $19

    ld a, $52                                     ; $04a7: $3e $52
    call Call_000_3e8a                            ; $04a9: $cd $8a $3e

Call_000_04ac:
    ld a, [$d363]                                 ; $04ac: $fa $63 $d3
    ld [$d71f], a                                 ; $04af: $ea $1f $d7
    call $6369                                    ; $04b2: $cd $69 $63
    ld a, [$d363]                                 ; $04b5: $fa $63 $d3
    call Call_000_12bc                            ; $04b8: $cd $bc $12
    ld hl, $d36c                                  ; $04bb: $21 $6c $d3
    set 7, [hl]                                   ; $04be: $cb $fe

jr_000_04c0:
    jp Jump_000_03a6                              ; $04c0: $c3 $a6 $03


jr_000_04c3:
    ld a, [$d05e]                                 ; $04c3: $fa $5e $d0
    and a                                         ; $04c6: $a7
    jp nz, Jump_000_062c                          ; $04c7: $c2 $2c $06

    jp Jump_000_03ff                              ; $04ca: $c3 $ff $03


Jump_000_04cd:
jr_000_04cd:
    ld hl, $cd60                                  ; $04cd: $21 $60 $cd
    res 2, [hl]                                   ; $04d0: $cb $96
    call Call_000_2425                            ; $04d2: $cd $25 $24
    ld a, $01                                     ; $04d5: $3e $01
    ld [$cc4b], a                                 ; $04d7: $ea $4b $cc
    ld a, [$d52d]                                 ; $04da: $fa $2d $d5
    and a                                         ; $04dd: $a7
    jp z, Jump_000_03ff                           ; $04de: $ca $ff $03

    ld [$d52e], a                                 ; $04e1: $ea $2e $d5
    xor a                                         ; $04e4: $af
    ld [$d52d], a                                 ; $04e5: $ea $2d $d5
    jp Jump_000_03ff                              ; $04e8: $c3 $ff $03


Jump_000_04eb:
    ldh a, [$b4]                                  ; $04eb: $f0 $b4

Jump_000_04ed:
    bit 7, a                                      ; $04ed: $cb $7f
    jr z, jr_000_04fa                             ; $04ef: $28 $09

    ld a, $01                                     ; $04f1: $3e $01
    ld [$c103], a                                 ; $04f3: $ea $03 $c1
    ld a, $04                                     ; $04f6: $3e $04
    jr jr_000_051d                                ; $04f8: $18 $23

jr_000_04fa:
    bit 6, a                                      ; $04fa: $cb $77
    jr z, jr_000_0507                             ; $04fc: $28 $09

Jump_000_04fe:
    ld a, $ff                                     ; $04fe: $3e $ff

Call_000_0500:
Jump_000_0500:
    ld [$c103], a                                 ; $0500: $ea $03 $c1
    ld a, $08                                     ; $0503: $3e $08
    jr jr_000_051d                                ; $0505: $18 $16

Jump_000_0507:
jr_000_0507:
    bit 5, a                                      ; $0507: $cb $6f
    jr z, jr_000_0514                             ; $0509: $28 $09

    ld a, $ff                                     ; $050b: $3e $ff
    ld [$c105], a                                 ; $050d: $ea $05 $c1
    ld a, $02                                     ; $0510: $3e $02
    jr jr_000_051d                                ; $0512: $18 $09

jr_000_0514:
    bit 4, a                                      ; $0514: $cb $67
    jr z, jr_000_04cd                             ; $0516: $28 $b5

    ld a, $01                                     ; $0518: $3e $01
    ld [$c105], a                                 ; $051a: $ea $05 $c1

jr_000_051d:
    ld [$d52f], a                                 ; $051d: $ea $2f $d5
    ld a, [$d735]                                 ; $0520: $fa $35 $d7

Call_000_0523:
    bit 7, a                                      ; $0523: $cb $7f
    jr nz, jr_000_057e                            ; $0525: $20 $57

    ld a, [$cc4b]                                 ; $0527: $fa $4b $cc
    and a                                         ; $052a: $a7
    jr z, jr_000_057e                             ; $052b: $28 $51

    ld a, [$d52f]                                 ; $052d: $fa $2f $d5
    ld b, a                                       ; $0530: $47
    ld a, [$d52e]                                 ; $0531: $fa $2e $d5
    cp b                                          ; $0534: $b8
    jr z, jr_000_057e                             ; $0535: $28 $47

    swap a                                        ; $0537: $cb $37
    or b                                          ; $0539: $b0
    cp $48                                        ; $053a: $fe $48
    jr nz, jr_000_0545                            ; $053c: $20 $07

    ld a, $02                                     ; $053e: $3e $02

Jump_000_0540:
    ld [$d52d], a                                 ; $0540: $ea $2d $d5
    jr jr_000_0564                                ; $0543: $18 $1f

Call_000_0545:
jr_000_0545:
    cp $84                                        ; $0545: $fe $84

Jump_000_0547:
    jr nz, jr_000_0550                            ; $0547: $20 $07

    ld a, $01                                     ; $0549: $3e $01

Jump_000_054b:
    ld [$d52d], a                                 ; $054b: $ea $2d $d5

Call_000_054e:
    jr jr_000_0564                                ; $054e: $18 $14

Jump_000_0550:
jr_000_0550:
    cp $12                                        ; $0550: $fe $12

Jump_000_0552:
    jr nz, jr_000_055b                            ; $0552: $20 $07

    ld a, $04                                     ; $0554: $3e $04

Jump_000_0556:
    ld [$d52d], a                                 ; $0556: $ea $2d $d5
    jr jr_000_0564                                ; $0559: $18 $09

jr_000_055b:
    cp $21                                        ; $055b: $fe $21
    jr nz, jr_000_0564                            ; $055d: $20 $05

    ld a, $08                                     ; $055f: $3e $08
    ld [$d52d], a                                 ; $0561: $ea $2d $d5

jr_000_0564:
    ld hl, $cd60                                  ; $0564: $21 $60 $cd
    set 2, [hl]                                   ; $0567: $cb $d6
    ld hl, $cc4b                                  ; $0569: $21 $4b $cc
    dec [hl]                                      ; $056c: $35

Jump_000_056d:
    jr nz, jr_000_0564                            ; $056d: $20 $f5

    ld a, [$d52f]                                 ; $056f: $fa $2f $d5
    ld [$d52d], a                                 ; $0572: $ea $2d $d5
    call Call_000_0683                            ; $0575: $cd $83 $06
    jp c, Jump_000_0637                           ; $0578: $da $37 $06

    jp Jump_000_03ff                              ; $057b: $c3 $ff $03


jr_000_057e:
    ld a, [$d52f]                                 ; $057e: $fa $2f $d5

Jump_000_0581:
    ld [$d52d], a                                 ; $0581: $ea $2d $d5
    call Call_000_2425                            ; $0584: $cd $25 $24
    ld a, [$d705]                                 ; $0587: $fa $05 $d7
    cp $02                                        ; $058a: $fe $02
    jr z, jr_000_05a8                             ; $058c: $28 $1a

    call Call_000_0bd1                            ; $058e: $cd $d1 $0b
    jr nc, jr_000_05ae                            ; $0591: $30 $1b

    push hl                                       ; $0593: $e5
    ld hl, $d73b                                  ; $0594: $21 $3b $d7
    bit 2, [hl]                                   ; $0597: $cb $56
    pop hl                                        ; $0599: $e1
    jp z, Jump_000_03ff                           ; $059a: $ca $ff $03

    push hl                                       ; $059d: $e5
    call Call_000_08e9                            ; $059e: $cd $e9 $08
    pop hl                                        ; $05a1: $e1
    jp c, Jump_000_0706                           ; $05a2: $da $06 $07

    jp Jump_000_03ff                              ; $05a5: $c3 $ff $03


jr_000_05a8:
    call Call_000_0fb7                            ; $05a8: $cd $b7 $0f
    jp c, Jump_000_03ff                           ; $05ab: $da $ff $03

jr_000_05ae:
    ld a, $08                                     ; $05ae: $3e $08

Jump_000_05b0:
    ld [$cfca], a                                 ; $05b0: $ea $ca $cf
    jr jr_000_05c7                                ; $05b3: $18 $12

Jump_000_05b5:
    ld a, [$d73b]                                 ; $05b5: $fa $3b $d7
    bit 7, a                                      ; $05b8: $cb $7f
    jr z, jr_000_05c4                             ; $05ba: $28 $08

    ld b, $11                                     ; $05bc: $06 $11
    ld hl, $4fd7                                  ; $05be: $21 $d7 $4f

Jump_000_05c1:
    call Call_000_35f3                            ; $05c1: $cd $f3 $35

jr_000_05c4:
    call Call_000_2425                            ; $05c4: $cd $25 $24

Call_000_05c7:
Jump_000_05c7:
jr_000_05c7:
    ld hl, $cd60                                  ; $05c7: $21 $60 $cd
    res 2, [hl]                                   ; $05ca: $cb $96
    ld a, [$d705]                                 ; $05cc: $fa $05 $d7
    dec a                                         ; $05cf: $3d
    jr nz, jr_000_05dc                            ; $05d0: $20 $0a

    ld a, [$d73b]                                 ; $05d2: $fa $3b $d7
    bit 6, a                                      ; $05d5: $cb $77
    jr nz, jr_000_05dc                            ; $05d7: $20 $03

    call Call_000_06a0                            ; $05d9: $cd $a0 $06

jr_000_05dc:
    call Call_000_0d27                            ; $05dc: $cd $27 $0d
    ld a, [$cfca]                                 ; $05df: $fa $ca $cf
    and a                                         ; $05e2: $a7
    jp nz, Jump_000_07ba                          ; $05e3: $c2 $ba $07

    ld a, [$d735]                                 ; $05e6: $fa $35 $d7
    bit 7, a                                      ; $05e9: $cb $7f
    jr nz, jr_000_0603                            ; $05eb: $20 $16

    ld hl, $d140                                  ; $05ed: $21 $40 $d1
    dec [hl]                                      ; $05f0: $35
    ld a, [$d731]                                 ; $05f1: $fa $31 $d7
    bit 0, a                                      ; $05f4: $cb $47

Jump_000_05f6:
    jr z, jr_000_0603                             ; $05f6: $28 $0b

    ld hl, $d141                                  ; $05f8: $21 $41 $d1
    dec [hl]                                      ; $05fb: $35
    jr nz, jr_000_0603                            ; $05fc: $20 $05

    ld hl, $d731                                  ; $05fe: $21 $31 $d7

Call_000_0601:
    res 0, [hl]                                   ; $0601: $cb $86

Jump_000_0603:
jr_000_0603:
    ld a, [$d795]                                 ; $0603: $fa $95 $d7

Jump_000_0606:
    bit 7, a                                      ; $0606: $cb $7f

Call_000_0608:
Jump_000_0608:
    jr z, jr_000_0619                             ; $0608: $28 $0f

    ld b, $07                                     ; $060a: $06 $07
    ld hl, $699a                                  ; $060c: $21 $9a $69
    call Call_000_35f3                            ; $060f: $cd $f3 $35
    ld a, [$da4b]                                 ; $0612: $fa $4b $da
    and a                                         ; $0615: $a7
    jp nz, Jump_000_073c                          ; $0616: $c2 $3c $07

jr_000_0619:
    ld a, [$d05c]                                 ; $0619: $fa $5c $d0
    and a                                         ; $061c: $a7
    jp nz, Jump_000_06b4                          ; $061d: $c2 $b4 $06

Jump_000_0620:
    ld a, $13                                     ; $0620: $3e $13
    call Call_000_3e8a                            ; $0622: $cd $8a $3e
    ld a, [$d132]                                 ; $0625: $fa $32 $d1

Jump_000_0628:
    and a                                         ; $0628: $a7
    jp nz, Jump_000_0931                          ; $0629: $c2 $31 $09

Jump_000_062c:
    call Call_000_0683                            ; $062c: $cd $83 $06
    ld hl, $d73b                                  ; $062f: $21 $3b $d7

Call_000_0632:
    res 2, [hl]                                   ; $0632: $cb $96
    jp nc, Jump_000_06b4                          ; $0634: $d2 $b4 $06

Jump_000_0637:
    ld hl, $d732                                  ; $0637: $21 $32 $d7
    res 6, [hl]                                   ; $063a: $cb $b6
    ld hl, $d738                                  ; $063c: $21 $38 $d7
    res 3, [hl]                                   ; $063f: $cb $9e
    ld hl, $d12b                                  ; $0641: $21 $2b $d1
    set 5, [hl]                                   ; $0644: $cb $ee
    set 6, [hl]                                   ; $0646: $cb $f6
    xor a                                         ; $0648: $af
    ldh [$b4], a                                  ; $0649: $e0 $b4
    ld a, [$d363]                                 ; $064b: $fa $63 $d3
    cp $a6                                        ; $064e: $fe $a6
    jr nz, jr_000_0657                            ; $0650: $20 $05

Jump_000_0652:
    ld hl, $d7a0                                  ; $0652: $21 $a0 $d7
    set 7, [hl]                                   ; $0655: $cb $fe

jr_000_0657:
    ld hl, $d733                                  ; $0657: $21 $33 $d7
    set 5, [hl]                                   ; $065a: $cb $ee
    ld a, [$d363]                                 ; $065c: $fa $63 $d3
    cp $28                                        ; $065f: $fe $28
    jp z, Jump_000_0670                           ; $0661: $ca $70 $06

    ld hl, $4a83                                  ; $0664: $21 $83 $4a
    ld b, $0f                                     ; $0667: $06 $0f
    call Call_000_35f3                            ; $0669: $cd $f3 $35
    ld a, d                                       ; $066c: $7a
    and a                                         ; $066d: $a7
    jr z, jr_000_0678                             ; $066e: $28 $08

Call_000_0670:
Jump_000_0670:
    ld c, $0a                                     ; $0670: $0e $0a
    call Call_000_3756                            ; $0672: $cd $56 $37
    jp Jump_000_03a6                              ; $0675: $c3 $a6 $03


jr_000_0678:
    ld a, $ff                                     ; $0678: $3e $ff
    ld [$d05c], a                                 ; $067a: $ea $5c $d0
    call Call_000_101b                            ; $067d: $cd $1b $10

Jump_000_0680:
    jp Jump_000_0931                              ; $0680: $c3 $31 $09


Call_000_0683:
Jump_000_0683:
    ld a, [$d732]                                 ; $0683: $fa $32 $d7
    bit 4, a                                      ; $0686: $cb $67

Call_000_0688:
    jr nz, jr_000_069e                            ; $0688: $20 $14

    call Call_000_311a                            ; $068a: $cd $1a $31

Call_000_068d:
    jr nz, jr_000_069e                            ; $068d: $20 $0f

    ld a, [$d733]                                 ; $068f: $fa $33 $d7
    bit 4, a                                      ; $0692: $cb $67
    jr nz, jr_000_069e                            ; $0694: $20 $08

    ld b, $0f                                     ; $0696: $06 $0f
    ld hl, $6f27                                  ; $0698: $21 $27 $6f
    jp Jump_000_35f3                              ; $069b: $c3 $f3 $35


Call_000_069e:
jr_000_069e:
    and a                                         ; $069e: $a7
    ret                                           ; $069f: $c9


Call_000_06a0:
    ld a, [$cc57]                                 ; $06a0: $fa $57 $cc
    and a                                         ; $06a3: $a7
    ret nz                                        ; $06a4: $c0

    ld a, [$d363]                                 ; $06a5: $fa $63 $d3
    cp $1c                                        ; $06a8: $fe $1c
    jr nz, jr_000_06b1                            ; $06aa: $20 $05

    ldh a, [$b4]                                  ; $06ac: $f0 $b4
    and $70                                       ; $06ae: $e6 $70
    ret nz                                        ; $06b0: $c0

Call_000_06b1:
jr_000_06b1:
    jp Jump_000_0d27                              ; $06b1: $c3 $27 $0d


Jump_000_06b4:
    ld a, [$d3b3]                                 ; $06b4: $fa $b3 $d3
    and a                                         ; $06b7: $a7
    jp z, Jump_000_07ba                           ; $06b8: $ca $ba $07

    ld a, [$d3b3]                                 ; $06bb: $fa $b3 $d3
    ld b, $00                                     ; $06be: $06 $00

Jump_000_06c0:
    ld c, a                                       ; $06c0: $4f

Call_000_06c1:
    ld a, [$d366]                                 ; $06c1: $fa $66 $d3
    ld d, a                                       ; $06c4: $57
    ld a, [$d367]                                 ; $06c5: $fa $67 $d3
    ld e, a                                       ; $06c8: $5f
    ld hl, $d3b4                                  ; $06c9: $21 $b4 $d3

Jump_000_06cc:
    ld a, [hl+]                                   ; $06cc: $2a
    cp d                                          ; $06cd: $ba
    jr nz, jr_000_072f                            ; $06ce: $20 $5f

    ld a, [hl+]                                   ; $06d0: $2a

Call_000_06d1:
    cp e                                          ; $06d1: $bb
    jr nz, jr_000_0730                            ; $06d2: $20 $5c

    push hl                                       ; $06d4: $e5
    push bc                                       ; $06d5: $c5
    ld hl, $d73b                                  ; $06d6: $21 $3b $d7
    set 2, [hl]                                   ; $06d9: $cb $d6
    ld b, $03                                     ; $06db: $06 $03
    ld hl, $449d                                  ; $06dd: $21 $9d $44

Jump_000_06e0:
    call Call_000_35f3                            ; $06e0: $cd $f3 $35
    pop bc                                        ; $06e3: $c1
    pop hl                                        ; $06e4: $e1
    jr c, jr_000_0735                             ; $06e5: $38 $4e

    push hl                                       ; $06e7: $e5
    push bc                                       ; $06e8: $c5
    call Call_000_08e9                            ; $06e9: $cd $e9 $08
    pop bc                                        ; $06ec: $c1
    pop hl                                        ; $06ed: $e1
    jr nc, jr_000_0730                            ; $06ee: $30 $40

Jump_000_06f0:
    ld a, [$d738]                                 ; $06f0: $fa $38 $d7
    bit 2, a                                      ; $06f3: $cb $57
    jr nz, jr_000_0735                            ; $06f5: $20 $3e

    push de                                       ; $06f7: $d5
    push bc                                       ; $06f8: $c5
    call Call_000_019a                            ; $06f9: $cd $9a $01
    pop bc                                        ; $06fc: $c1
    pop de                                        ; $06fd: $d1
    ldh a, [$b4]                                  ; $06fe: $f0 $b4

Jump_000_0700:
    and $f0                                       ; $0700: $e6 $f0

Call_000_0702:
    jr z, jr_000_0730                             ; $0702: $28 $2c

Jump_000_0704:
    jr jr_000_0735                                ; $0704: $18 $2f

Jump_000_0706:
    ld a, [$d3b3]                                 ; $0706: $fa $b3 $d3
    ld c, a                                       ; $0709: $4f

Jump_000_070a:
    ld hl, $d3b4                                  ; $070a: $21 $b4 $d3

jr_000_070d:
    ld a, [hl+]                                   ; $070d: $2a
    ld b, a                                       ; $070e: $47
    ld a, [$d366]                                 ; $070f: $fa $66 $d3

Jump_000_0712:
    cp b                                          ; $0712: $b8
    jr nz, jr_000_0726                            ; $0713: $20 $11

    ld a, [hl+]                                   ; $0715: $2a
    ld b, a                                       ; $0716: $47
    ld a, [$d367]                                 ; $0717: $fa $67 $d3
    cp b                                          ; $071a: $b8
    jr nz, jr_000_0727                            ; $071b: $20 $0a

    ld a, [hl+]                                   ; $071d: $2a
    ld [$d434], a                                 ; $071e: $ea $34 $d4

Jump_000_0721:
    ld a, [hl]                                    ; $0721: $7e
    ldh [$8b], a                                  ; $0722: $e0 $8b
    jr jr_000_073c                                ; $0724: $18 $16

jr_000_0726:
    inc hl                                        ; $0726: $23

jr_000_0727:
    inc hl                                        ; $0727: $23

Jump_000_0728:
    inc hl                                        ; $0728: $23
    dec c                                         ; $0729: $0d
    jr nz, jr_000_070d                            ; $072a: $20 $e1

    jp Jump_000_03ff                              ; $072c: $c3 $ff $03


jr_000_072f:
    inc hl                                        ; $072f: $23

Call_000_0730:
jr_000_0730:
    inc hl                                        ; $0730: $23
    inc hl                                        ; $0731: $23
    jp Jump_000_07b5                              ; $0732: $c3 $b5 $07


jr_000_0735:
    ld a, [hl+]                                   ; $0735: $2a
    ld [$d434], a                                 ; $0736: $ea $34 $d4
    ld a, [hl+]                                   ; $0739: $2a
    ldh [$8b], a                                  ; $073a: $e0 $8b

Jump_000_073c:
jr_000_073c:
    ld a, [$d3b3]                                 ; $073c: $fa $b3 $d3
    sub c                                         ; $073f: $91

Jump_000_0740:
    ld [$d740], a                                 ; $0740: $ea $40 $d7

Call_000_0743:
Jump_000_0743:
    ld a, [$d363]                                 ; $0743: $fa $63 $d3

Call_000_0746:
    ld [$d741], a                                 ; $0746: $ea $41 $d7

Jump_000_0749:
    call Call_000_08e1                            ; $0749: $cd $e1 $08

Call_000_074c:
    jr nz, jr_000_0770                            ; $074c: $20 $22

Call_000_074e:
    ld a, [$d363]                                 ; $074e: $fa $63 $d3

Jump_000_0751:
    ld [$d36a], a                                 ; $0751: $ea $6a $d3
    ld a, [$d36e]                                 ; $0754: $fa $6e $d3
    ld [$d36b], a                                 ; $0757: $ea $6b $d3
    ldh a, [$8b]                                  ; $075a: $f0 $8b
    ld [$d363], a                                 ; $075c: $ea $63 $d3
    cp $52                                        ; $075f: $fe $52
    jr nz, jr_000_076b                            ; $0761: $20 $08

    ld a, $06                                     ; $0763: $3e $06
    ld [$d362], a                                 ; $0765: $ea $62 $d3
    call Call_000_20eb                            ; $0768: $cd $eb $20

jr_000_076b:
    call Call_000_08c9                            ; $076b: $cd $c9 $08
    jr jr_000_07aa                                ; $076e: $18 $3a

Call_000_0770:
jr_000_0770:
    ldh a, [$8b]                                  ; $0770: $f0 $8b
    cp $ff                                        ; $0772: $fe $ff
    jr z, jr_000_079d                             ; $0774: $28 $27

    ld [$d363], a                                 ; $0776: $ea $63 $d3

Jump_000_0779:
    ld b, $1c                                     ; $0779: $06 $1c
    ld hl, $4788                                  ; $077b: $21 $88 $47
    call Call_000_35f3                            ; $077e: $cd $f3 $35

Jump_000_0781:
    ld a, [$cd5b]                                 ; $0781: $fa $5b $cd
    dec a                                         ; $0784: $3d
    jr nz, jr_000_0791                            ; $0785: $20 $0a

    ld hl, $d737                                  ; $0787: $21 $37 $d7
    set 3, [hl]                                   ; $078a: $cb $de
    call Call_000_098f                            ; $078c: $cd $8f $09
    jr jr_000_0794                                ; $078f: $18 $03

jr_000_0791:
    call Call_000_08c9                            ; $0791: $cd $c9 $08

jr_000_0794:
    ld hl, $d73b                                  ; $0794: $21 $3b $d7
    res 0, [hl]                                   ; $0797: $cb $86
    res 1, [hl]                                   ; $0799: $cb $8e
    jr jr_000_07aa                                ; $079b: $18 $0d

jr_000_079d:
    ld a, [$d36a]                                 ; $079d: $fa $6a $d3
    ld [$d363], a                                 ; $07a0: $ea $63 $d3
    call Call_000_08c9                            ; $07a3: $cd $c9 $08
    xor a                                         ; $07a6: $af
    ld [$d362], a                                 ; $07a7: $ea $62 $d3

jr_000_07aa:
    ld hl, $d73b                                  ; $07aa: $21 $3b $d7
    set 0, [hl]                                   ; $07ad: $cb $c6
    call Call_000_12da                            ; $07af: $cd $da $12
    jp Jump_000_03a6                              ; $07b2: $c3 $a6 $03


Jump_000_07b5:
    inc b                                         ; $07b5: $04
    dec c                                         ; $07b6: $0d

Call_000_07b7:
    jp nz, Jump_000_06cc                          ; $07b7: $c2 $cc $06

Jump_000_07ba:
    ld a, [$d367]                                 ; $07ba: $fa $67 $d3

Call_000_07bd:
    cp $ff                                        ; $07bd: $fe $ff
    jr nz, jr_000_07fe                            ; $07bf: $20 $3d

Call_000_07c1:
    ld a, [$d38c]                                 ; $07c1: $fa $8c $d3
    ld [$d363], a                                 ; $07c4: $ea $63 $d3

Call_000_07c7:
    ld a, [$d394]                                 ; $07c7: $fa $94 $d3
    ld [$d367], a                                 ; $07ca: $ea $67 $d3
    ld a, [$d366]                                 ; $07cd: $fa $66 $d3
    ld c, a                                       ; $07d0: $4f
    ld a, [$d393]                                 ; $07d1: $fa $93 $d3
    add c                                         ; $07d4: $81
    ld c, a                                       ; $07d5: $4f
    ld [$d366], a                                 ; $07d6: $ea $66 $d3
    ld a, [$d395]                                 ; $07d9: $fa $95 $d3
    ld l, a                                       ; $07dc: $6f
    ld a, [$d396]                                 ; $07dd: $fa $96 $d3
    ld h, a                                       ; $07e0: $67

Jump_000_07e1:
    srl c                                         ; $07e1: $cb $39
    jr z, jr_000_07f3                             ; $07e3: $28 $0e

jr_000_07e5:
    ld a, [$d392]                                 ; $07e5: $fa $92 $d3
    add $06                                       ; $07e8: $c6 $06
    ld e, a                                       ; $07ea: $5f
    ld d, $00                                     ; $07eb: $16 $00
    ld b, $00                                     ; $07ed: $06 $00
    add hl, de                                    ; $07ef: $19
    dec c                                         ; $07f0: $0d
    jr nz, jr_000_07e5                            ; $07f1: $20 $f2

jr_000_07f3:
    ld a, l                                       ; $07f3: $7d
    ld [$d364], a                                 ; $07f4: $ea $64 $d3
    ld a, h                                       ; $07f7: $7c
    ld [$d365], a                                 ; $07f8: $ea $65 $d3
    jp Jump_000_08ad                              ; $07fb: $c3 $ad $08


jr_000_07fe:
    ld b, a                                       ; $07fe: $47
    ld a, [$d52a]                                 ; $07ff: $fa $2a $d5
    cp b                                          ; $0802: $b8
    jr nz, jr_000_0842                            ; $0803: $20 $3d

    ld a, [$d397]                                 ; $0805: $fa $97 $d3
    ld [$d363], a                                 ; $0808: $ea $63 $d3
    ld a, [$d39f]                                 ; $080b: $fa $9f $d3
    ld [$d367], a                                 ; $080e: $ea $67 $d3
    ld a, [$d366]                                 ; $0811: $fa $66 $d3
    ld c, a                                       ; $0814: $4f
    ld a, [$d39e]                                 ; $0815: $fa $9e $d3
    add c                                         ; $0818: $81
    ld c, a                                       ; $0819: $4f
    ld [$d366], a                                 ; $081a: $ea $66 $d3
    ld a, [$d3a0]                                 ; $081d: $fa $a0 $d3
    ld l, a                                       ; $0820: $6f
    ld a, [$d3a1]                                 ; $0821: $fa $a1 $d3
    ld h, a                                       ; $0824: $67
    srl c                                         ; $0825: $cb $39
    jr z, jr_000_0837                             ; $0827: $28 $0e

jr_000_0829:
    ld a, [$d39d]                                 ; $0829: $fa $9d $d3
    add $06                                       ; $082c: $c6 $06
    ld e, a                                       ; $082e: $5f
    ld d, $00                                     ; $082f: $16 $00
    ld b, $00                                     ; $0831: $06 $00
    add hl, de                                    ; $0833: $19
    dec c                                         ; $0834: $0d
    jr nz, jr_000_0829                            ; $0835: $20 $f2

jr_000_0837:
    ld a, l                                       ; $0837: $7d
    ld [$d364], a                                 ; $0838: $ea $64 $d3
    ld a, h                                       ; $083b: $7c
    ld [$d365], a                                 ; $083c: $ea $65 $d3
    jp Jump_000_08ad                              ; $083f: $c3 $ad $08


jr_000_0842:
    ld a, [$d366]                                 ; $0842: $fa $66 $d3
    cp $ff                                        ; $0845: $fe $ff
    jr nz, jr_000_0879                            ; $0847: $20 $30

    ld a, [$d376]                                 ; $0849: $fa $76 $d3
    ld [$d363], a                                 ; $084c: $ea $63 $d3
    ld a, [$d37d]                                 ; $084f: $fa $7d $d3
    ld [$d366], a                                 ; $0852: $ea $66 $d3

Jump_000_0855:
    ld a, [$d367]                                 ; $0855: $fa $67 $d3
    ld c, a                                       ; $0858: $4f
    ld a, [$d37e]                                 ; $0859: $fa $7e $d3
    add c                                         ; $085c: $81
    ld c, a                                       ; $085d: $4f
    ld [$d367], a                                 ; $085e: $ea $67 $d3
    ld a, [$d37f]                                 ; $0861: $fa $7f $d3
    ld l, a                                       ; $0864: $6f
    ld a, [$d380]                                 ; $0865: $fa $80 $d3
    ld h, a                                       ; $0868: $67
    ld b, $00                                     ; $0869: $06 $00
    srl c                                         ; $086b: $cb $39
    add hl, bc                                    ; $086d: $09
    ld a, l                                       ; $086e: $7d
    ld [$d364], a                                 ; $086f: $ea $64 $d3
    ld a, h                                       ; $0872: $7c
    ld [$d365], a                                 ; $0873: $ea $65 $d3
    jp Jump_000_08ad                              ; $0876: $c3 $ad $08


jr_000_0879:
    ld b, a                                       ; $0879: $47
    ld a, [$d529]                                 ; $087a: $fa $29 $d5
    cp b                                          ; $087d: $b8
    jr nz, jr_000_08c6                            ; $087e: $20 $46

    ld a, [$d381]                                 ; $0880: $fa $81 $d3
    ld [$d363], a                                 ; $0883: $ea $63 $d3
    ld a, [$d388]                                 ; $0886: $fa $88 $d3
    ld [$d366], a                                 ; $0889: $ea $66 $d3
    ld a, [$d367]                                 ; $088c: $fa $67 $d3
    ld c, a                                       ; $088f: $4f
    ld a, [$d389]                                 ; $0890: $fa $89 $d3
    add c                                         ; $0893: $81
    ld c, a                                       ; $0894: $4f
    ld [$d367], a                                 ; $0895: $ea $67 $d3
    ld a, [$d38a]                                 ; $0898: $fa $8a $d3
    ld l, a                                       ; $089b: $6f
    ld a, [$d38b]                                 ; $089c: $fa $8b $d3
    ld h, a                                       ; $089f: $67
    ld b, $00                                     ; $08a0: $06 $00
    srl c                                         ; $08a2: $cb $39
    add hl, bc                                    ; $08a4: $09
    ld a, l                                       ; $08a5: $7d
    ld [$d364], a                                 ; $08a6: $ea $64 $d3
    ld a, h                                       ; $08a9: $7c
    ld [$d365], a                                 ; $08aa: $ea $65 $d3

Jump_000_08ad:
    call Call_000_107c                            ; $08ad: $cd $7c $10
    call Call_000_230e                            ; $08b0: $cd $0e $23
    ld b, $09                                     ; $08b3: $06 $09
    call Call_000_3e0c                            ; $08b5: $cd $0c $3e
    ld b, $05                                     ; $08b8: $06 $05
    ld hl, $785b                                  ; $08ba: $21 $5b $78
    call Call_000_35f3                            ; $08bd: $cd $f3 $35
    call Call_000_09fc                            ; $08c0: $cd $fc $09
    jp Jump_000_0402                              ; $08c3: $c3 $02 $04


jr_000_08c6:
    jp Jump_000_03ff                              ; $08c6: $c3 $ff $03


Call_000_08c9:
    ld a, [$c448]                                 ; $08c9: $fa $48 $c4
    cp $0b                                        ; $08cc: $fe $0b
    jr nz, jr_000_08d4                            ; $08ce: $20 $04

    ld a, $ad                                     ; $08d0: $3e $ad
    jr jr_000_08d6                                ; $08d2: $18 $02

jr_000_08d4:
    ld a, $b5                                     ; $08d4: $3e $b5

jr_000_08d6:
    call Call_000_23ad                            ; $08d6: $cd $ad $23
    ld a, [$d362]                                 ; $08d9: $fa $62 $d3
    and a                                         ; $08dc: $a7
    ret nz                                        ; $08dd: $c0

    jp Jump_000_20eb                              ; $08de: $c3 $eb $20


Call_000_08e1:
    ld a, [$d36c]                                 ; $08e1: $fa $6c $d3
    and a                                         ; $08e4: $a7
    ret z                                         ; $08e5: $c8

    cp $17                                        ; $08e6: $fe $17
    ret                                           ; $08e8: $c9


Call_000_08e9:
    ld a, [$d363]                                 ; $08e9: $fa $63 $d3
    cp $61                                        ; $08ec: $fe $61
    jr z, jr_000_0912                             ; $08ee: $28 $22

    cp $c7                                        ; $08f0: $fe $c7
    jr z, jr_000_0917                             ; $08f2: $28 $23

    cp $c8                                        ; $08f4: $fe $c8
    jr z, jr_000_0917                             ; $08f6: $28 $1f

Call_000_08f8:
    cp $ca                                        ; $08f8: $fe $ca
    jr z, jr_000_0917                             ; $08fa: $28 $1b

    cp $52                                        ; $08fc: $fe $52
    jr z, jr_000_0917                             ; $08fe: $28 $17

    ld a, [$d36c]                                 ; $0900: $fa $6c $d3
    and a                                         ; $0903: $a7
    jr z, jr_000_0917                             ; $0904: $28 $11

    cp $0d                                        ; $0906: $fe $0d
    jr z, jr_000_0917                             ; $0908: $28 $0d

    cp $0e                                        ; $090a: $fe $0e
    jr z, jr_000_0917                             ; $090c: $28 $09

    cp $17                                        ; $090e: $fe $17
    jr z, jr_000_0917                             ; $0910: $28 $05

Call_000_0912:
jr_000_0912:
    ld hl, $43ff                                  ; $0912: $21 $ff $43
    jr jr_000_091a                                ; $0915: $18 $03

jr_000_0917:
    ld hl, $444e                                  ; $0917: $21 $4e $44

jr_000_091a:
    ld b, $03                                     ; $091a: $06 $03
    jp Jump_000_35f3                              ; $091c: $c3 $f3 $35


Call_000_091f:
    ld b, $03                                     ; $091f: $06 $03
    ld hl, $435f                                  ; $0921: $21 $5f $43
    call Call_000_35f3                            ; $0924: $cd $f3 $35
    ld a, [$d362]                                 ; $0927: $fa $62 $d3
    and a                                         ; $092a: $a7
    jp z, Jump_000_20f2                           ; $092b: $ca $f2 $20

    jp Jump_000_20b6                              ; $092e: $c3 $b6 $20


Jump_000_0931:
    call Call_000_20eb                            ; $0931: $cd $eb $20
    ld a, $08                                     ; $0934: $3e $08
    call Call_000_0951                            ; $0936: $cd $51 $09
    ld hl, $d733                                  ; $0939: $21 $33 $d7
    res 5, [hl]                                   ; $093c: $cb $ae
    ld a, $01                                     ; $093e: $3e $01
    ldh [$b8], a                                  ; $0940: $e0 $b8
    ld [$2000], a                                 ; $0942: $ea $00 $20
    call $40b0                                    ; $0945: $cd $b0 $40
    call $6369                                    ; $0948: $cd $69 $63
    call Call_000_230e                            ; $094b: $cd $0e $23
    jp $5ded                                      ; $094e: $c3 $ed $5d


Call_000_0951:
    ld [$cfcc], a                                 ; $0951: $ea $cc $cf
    ld a, $ff                                     ; $0954: $3e $ff
    ld [$c0ee], a                                 ; $0956: $ea $ee $c0
    call Call_000_23ad                            ; $0959: $cd $ad $23

jr_000_095c:
    ld a, [$cfcc]                                 ; $095c: $fa $cc $cf
    and a                                         ; $095f: $a7
    jr nz, jr_000_095c                            ; $0960: $20 $fa

    jp Jump_000_200a                              ; $0962: $c3 $0a $20


Jump_000_0965:
    call Call_000_2425                            ; $0965: $cd $25 $24
    call Call_000_3df4                            ; $0968: $cd $f4 $3d
    xor a                                         ; $096b: $af
    ld [$cf10], a                                 ; $096c: $ea $10 $cf
    ld [$d705], a                                 ; $096f: $ea $05 $d7
    ld [$d05c], a                                 ; $0972: $ea $5c $d0
    ld [$d362], a                                 ; $0975: $ea $62 $d3
    ld hl, $d737                                  ; $0978: $21 $37 $d7
    set 2, [hl]                                   ; $097b: $cb $d6
    res 5, [hl]                                   ; $097d: $cb $ae
    call Call_000_098f                            ; $097f: $cd $8f $09
    ld a, $01                                     ; $0982: $3e $01
    ldh [$b8], a                                  ; $0984: $e0 $b8
    ld [$2000], a                                 ; $0986: $ea $00 $20
    call $6369                                    ; $0989: $cd $69 $63
    jp $5ded                                      ; $098c: $c3 $ed $5d


Call_000_098f:
    ld b, $1c                                     ; $098f: $06 $1c
    ld hl, $45bb                                  ; $0991: $21 $bb $45
    jp Jump_000_35f3                              ; $0994: $c3 $f3 $35


Call_000_0997:
Jump_000_0997:
    ld a, [$d705]                                 ; $0997: $fa $05 $d7
    dec a                                         ; $099a: $3d
    jr z, jr_000_09a4                             ; $099b: $28 $07

    ldh a, [$d7]                                  ; $099d: $f0 $d7
    and a                                         ; $099f: $a7
    jr nz, jr_000_09b3                            ; $09a0: $20 $11

    jr jr_000_09a9                                ; $09a2: $18 $05

jr_000_09a4:
    call Call_000_09c5                            ; $09a4: $cd $c5 $09
    jr c, jr_000_09b3                             ; $09a7: $38 $0a

Call_000_09a9:
Jump_000_09a9:
jr_000_09a9:
    xor a                                         ; $09a9: $af
    ld [$d705], a                                 ; $09aa: $ea $05 $d7
    ld [$d11f], a                                 ; $09ad: $ea $1f $d1
    jp Jump_000_104d                              ; $09b0: $c3 $4d $10


jr_000_09b3:
    ld a, [$d705]                                 ; $09b3: $fa $05 $d7
    and a                                         ; $09b6: $a7
    jp z, Jump_000_104d                           ; $09b7: $ca $4d $10

Jump_000_09ba:
    dec a                                         ; $09ba: $3d
    jp z, Jump_000_105d                           ; $09bb: $ca $5d $10

    dec a                                         ; $09be: $3d
    jp z, Jump_000_1055                           ; $09bf: $ca $55 $10

    jp Jump_000_104d                              ; $09c2: $c3 $4d $10


Call_000_09c5:
    ld a, [$d363]                                 ; $09c5: $fa $63 $d3
    cp $22                                        ; $09c8: $fe $22
    jr z, jr_000_09e0                             ; $09ca: $28 $14

    cp $09                                        ; $09cc: $fe $09
    jr z, jr_000_09e0                             ; $09ce: $28 $10

    ld a, [$d36c]                                 ; $09d0: $fa $6c $d3
    ld b, a                                       ; $09d3: $47
    ld hl, $09e2                                  ; $09d4: $21 $e2 $09

jr_000_09d7:
    ld a, [hl+]                                   ; $09d7: $2a
    cp b                                          ; $09d8: $b8
    jr z, jr_000_09e0                             ; $09d9: $28 $05

    inc a                                         ; $09db: $3c
    jr nz, jr_000_09d7                            ; $09dc: $20 $f9

    and a                                         ; $09de: $a7
    ret                                           ; $09df: $c9


jr_000_09e0:
    scf                                           ; $09e0: $37
    ret                                           ; $09e1: $c9


    nop                                           ; $09e2: $00
    inc bc                                        ; $09e3: $03
    dec bc                                        ; $09e4: $0b
    ld c, $11                                     ; $09e5: $0e $11
    rst $38                                       ; $09e7: $ff

Call_000_09e8:
    ld a, [$d533]                                 ; $09e8: $fa $33 $d5
    ld l, a                                       ; $09eb: $6f
    ld a, [$d534]                                 ; $09ec: $fa $34 $d5
    ld h, a                                       ; $09ef: $67
    ld de, $9000                                  ; $09f0: $11 $00 $90
    ld bc, $0600                                  ; $09f3: $01 $00 $06

Jump_000_09f6:
    ld a, [$d530]                                 ; $09f6: $fa $30 $d5

Jump_000_09f9:
    jp Jump_000_17f4                              ; $09f9: $c3 $f4 $17


Call_000_09fc:
    ld hl, $c6e8                                  ; $09fc: $21 $e8 $c6
    ld a, [$d3b2]                                 ; $09ff: $fa $b2 $d3

Jump_000_0a02:
    ld d, a                                       ; $0a02: $57
    ld bc, $0514                                  ; $0a03: $01 $14 $05

Call_000_0a06:
Jump_000_0a06:
jr_000_0a06:
    ld a, d                                       ; $0a06: $7a
    ld [hl+], a                                   ; $0a07: $22
    dec bc                                        ; $0a08: $0b

Call_000_0a09:
Jump_000_0a09:
    ld a, c                                       ; $0a09: $79
    or b                                          ; $0a0a: $b0
    jr nz, jr_000_0a06                            ; $0a0b: $20 $f9

    ld hl, $c6e8                                  ; $0a0d: $21 $e8 $c6
    ld a, [$d36e]                                 ; $0a10: $fa $6e $d3
    ldh [$8c], a                                  ; $0a13: $e0 $8c
    add $06                                       ; $0a15: $c6 $06
    ldh [$8b], a                                  ; $0a17: $e0 $8b
    ld b, $00                                     ; $0a19: $06 $00
    ld c, a                                       ; $0a1b: $4f
    add hl, bc                                    ; $0a1c: $09
    add hl, bc                                    ; $0a1d: $09
    add hl, bc                                    ; $0a1e: $09
    ld c, $03                                     ; $0a1f: $0e $03
    add hl, bc                                    ; $0a21: $09
    ld a, [$d36f]                                 ; $0a22: $fa $6f $d3
    ld e, a                                       ; $0a25: $5f
    ld a, [$d370]                                 ; $0a26: $fa $70 $d3
    ld d, a                                       ; $0a29: $57
    ld a, [$d36d]                                 ; $0a2a: $fa $6d $d3
    ld b, a                                       ; $0a2d: $47

jr_000_0a2e:
    push hl                                       ; $0a2e: $e5
    ldh a, [$8c]                                  ; $0a2f: $f0 $8c
    ld c, a                                       ; $0a31: $4f

jr_000_0a32:
    ld a, [de]                                    ; $0a32: $1a
    inc de                                        ; $0a33: $13
    ld [hl+], a                                   ; $0a34: $22
    dec c                                         ; $0a35: $0d
    jr nz, jr_000_0a32                            ; $0a36: $20 $fa

    pop hl                                        ; $0a38: $e1
    ldh a, [$8b]                                  ; $0a39: $f0 $8b
    add l                                         ; $0a3b: $85
    ld l, a                                       ; $0a3c: $6f
    jr nc, jr_000_0a40                            ; $0a3d: $30 $01

    inc h                                         ; $0a3f: $24

jr_000_0a40:
    dec b                                         ; $0a40: $05
    jr nz, jr_000_0a2e                            ; $0a41: $20 $eb

    ld a, [$d376]                                 ; $0a43: $fa $76 $d3
    cp $ff                                        ; $0a46: $fe $ff
    jr z, jr_000_0a6a                             ; $0a48: $28 $20

Call_000_0a4a:
    call Call_000_12bc                            ; $0a4a: $cd $bc $12
    ld a, [$d377]                                 ; $0a4d: $fa $77 $d3
    ld l, a                                       ; $0a50: $6f
    ld a, [$d378]                                 ; $0a51: $fa $78 $d3
    ld h, a                                       ; $0a54: $67

Call_000_0a55:
    ld a, [$d379]                                 ; $0a55: $fa $79 $d3
    ld e, a                                       ; $0a58: $5f
    ld a, [$d37a]                                 ; $0a59: $fa $7a $d3

Jump_000_0a5c:
    ld d, a                                       ; $0a5c: $57
    ld a, [$d37b]                                 ; $0a5d: $fa $7b $d3
    ldh [$8b], a                                  ; $0a60: $e0 $8b
    ld a, [$d37c]                                 ; $0a62: $fa $7c $d3
    ldh [$8c], a                                  ; $0a65: $e0 $8c
    call Call_000_0ade                            ; $0a67: $cd $de $0a

jr_000_0a6a:
    ld a, [$d381]                                 ; $0a6a: $fa $81 $d3

Call_000_0a6d:
    cp $ff                                        ; $0a6d: $fe $ff
    jr z, jr_000_0a91                             ; $0a6f: $28 $20

    call Call_000_12bc                            ; $0a71: $cd $bc $12
    ld a, [$d382]                                 ; $0a74: $fa $82 $d3
    ld l, a                                       ; $0a77: $6f
    ld a, [$d383]                                 ; $0a78: $fa $83 $d3
    ld h, a                                       ; $0a7b: $67
    ld a, [$d384]                                 ; $0a7c: $fa $84 $d3
    ld e, a                                       ; $0a7f: $5f
    ld a, [$d385]                                 ; $0a80: $fa $85 $d3
    ld d, a                                       ; $0a83: $57

Call_000_0a84:
    ld a, [$d386]                                 ; $0a84: $fa $86 $d3
    ldh [$8b], a                                  ; $0a87: $e0 $8b
    ld a, [$d387]                                 ; $0a89: $fa $87 $d3
    ldh [$8c], a                                  ; $0a8c: $e0 $8c
    call Call_000_0ade                            ; $0a8e: $cd $de $0a

jr_000_0a91:
    ld a, [$d38c]                                 ; $0a91: $fa $8c $d3
    cp $ff                                        ; $0a94: $fe $ff
    jr z, jr_000_0ab7                             ; $0a96: $28 $1f

    call Call_000_12bc                            ; $0a98: $cd $bc $12
    ld a, [$d38d]                                 ; $0a9b: $fa $8d $d3
    ld l, a                                       ; $0a9e: $6f
    ld a, [$d38e]                                 ; $0a9f: $fa $8e $d3
    ld h, a                                       ; $0aa2: $67
    ld a, [$d38f]                                 ; $0aa3: $fa $8f $d3
    ld e, a                                       ; $0aa6: $5f

Call_000_0aa7:
    ld a, [$d390]                                 ; $0aa7: $fa $90 $d3
    ld d, a                                       ; $0aaa: $57
    ld a, [$d391]                                 ; $0aab: $fa $91 $d3
    ld b, a                                       ; $0aae: $47
    ld a, [$d392]                                 ; $0aaf: $fa $92 $d3
    ldh [$8b], a                                  ; $0ab2: $e0 $8b
    call Call_000_0b02                            ; $0ab4: $cd $02 $0b

jr_000_0ab7:
    ld a, [$d397]                                 ; $0ab7: $fa $97 $d3
    cp $ff                                        ; $0aba: $fe $ff
    jr z, jr_000_0add                             ; $0abc: $28 $1f

    call Call_000_12bc                            ; $0abe: $cd $bc $12
    ld a, [$d398]                                 ; $0ac1: $fa $98 $d3
    ld l, a                                       ; $0ac4: $6f

Call_000_0ac5:
    ld a, [$d399]                                 ; $0ac5: $fa $99 $d3
    ld h, a                                       ; $0ac8: $67
    ld a, [$d39a]                                 ; $0ac9: $fa $9a $d3
    ld e, a                                       ; $0acc: $5f
    ld a, [$d39b]                                 ; $0acd: $fa $9b $d3
    ld d, a                                       ; $0ad0: $57
    ld a, [$d39c]                                 ; $0ad1: $fa $9c $d3
    ld b, a                                       ; $0ad4: $47
    ld a, [$d39d]                                 ; $0ad5: $fa $9d $d3
    ldh [$8b], a                                  ; $0ad8: $e0 $8b
    call Call_000_0b02                            ; $0ada: $cd $02 $0b

jr_000_0add:
    ret                                           ; $0add: $c9


Call_000_0ade:
    ld c, $03                                     ; $0ade: $0e $03

jr_000_0ae0:
    push de                                       ; $0ae0: $d5
    push hl                                       ; $0ae1: $e5
    ldh a, [$8b]                                  ; $0ae2: $f0 $8b
    ld b, a                                       ; $0ae4: $47

jr_000_0ae5:
    ld a, [hl+]                                   ; $0ae5: $2a
    ld [de], a                                    ; $0ae6: $12
    inc de                                        ; $0ae7: $13
    dec b                                         ; $0ae8: $05
    jr nz, jr_000_0ae5                            ; $0ae9: $20 $fa

Call_000_0aeb:
    pop hl                                        ; $0aeb: $e1
    pop de                                        ; $0aec: $d1
    ldh a, [$8c]                                  ; $0aed: $f0 $8c
    add l                                         ; $0aef: $85
    ld l, a                                       ; $0af0: $6f
    jr nc, jr_000_0af4                            ; $0af1: $30 $01

    inc h                                         ; $0af3: $24

jr_000_0af4:
    ld a, [$d36e]                                 ; $0af4: $fa $6e $d3
    add $06                                       ; $0af7: $c6 $06
    add e                                         ; $0af9: $83
    ld e, a                                       ; $0afa: $5f
    jr nc, jr_000_0afe                            ; $0afb: $30 $01

    inc d                                         ; $0afd: $14

Jump_000_0afe:
jr_000_0afe:
    dec c                                         ; $0afe: $0d
    jr nz, jr_000_0ae0                            ; $0aff: $20 $df

Jump_000_0b01:
    ret                                           ; $0b01: $c9


Call_000_0b02:
jr_000_0b02:
    push hl                                       ; $0b02: $e5
    push de                                       ; $0b03: $d5
    ld c, $03                                     ; $0b04: $0e $03

Call_000_0b06:
jr_000_0b06:
    ld a, [hl+]                                   ; $0b06: $2a

Jump_000_0b07:
    ld [de], a                                    ; $0b07: $12
    inc de                                        ; $0b08: $13
    dec c                                         ; $0b09: $0d
    jr nz, jr_000_0b06                            ; $0b0a: $20 $fa

    pop de                                        ; $0b0c: $d1
    pop hl                                        ; $0b0d: $e1
    ldh a, [$8b]                                  ; $0b0e: $f0 $8b
    add l                                         ; $0b10: $85
    ld l, a                                       ; $0b11: $6f
    jr nc, jr_000_0b15                            ; $0b12: $30 $01

    inc h                                         ; $0b14: $24

jr_000_0b15:
    ld a, [$d36e]                                 ; $0b15: $fa $6e $d3
    add $06                                       ; $0b18: $c6 $06
    add e                                         ; $0b1a: $83
    ld e, a                                       ; $0b1b: $5f
    jr nc, jr_000_0b1f                            ; $0b1c: $30 $01

    inc d                                         ; $0b1e: $14

jr_000_0b1f:
    dec b                                         ; $0b1f: $05
    jr nz, jr_000_0b02                            ; $0b20: $20 $e0

    ret                                           ; $0b22: $c9


Call_000_0b23:
    xor a                                         ; $0b23: $af
    ldh [$8c], a                                  ; $0b24: $e0 $8c
    ld a, [$d4b5]                                 ; $0b26: $fa $b5 $d4
    and a                                         ; $0b29: $a7
    jr z, jr_000_0b58                             ; $0b2a: $28 $2c

    ld a, $35                                     ; $0b2c: $3e $35
    call Call_000_3e8a                            ; $0b2e: $cd $8a $3e

Call_000_0b31:
    ld hl, $d4b6                                  ; $0b31: $21 $b6 $d4
    ld a, [$d4b5]                                 ; $0b34: $fa $b5 $d4
    ld b, a                                       ; $0b37: $47
    ld c, $00                                     ; $0b38: $0e $00

jr_000_0b3a:
    inc c                                         ; $0b3a: $0c
    ld a, [hl+]                                   ; $0b3b: $2a
    cp d                                          ; $0b3c: $ba
    jr z, jr_000_0b42                             ; $0b3d: $28 $03

    inc hl                                        ; $0b3f: $23
    jr jr_000_0b55                                ; $0b40: $18 $13

jr_000_0b42:
    ld a, [hl+]                                   ; $0b42: $2a
    cp e                                          ; $0b43: $bb
    jr nz, jr_000_0b55                            ; $0b44: $20 $0f

    push hl                                       ; $0b46: $e5
    push bc                                       ; $0b47: $c5
    ld hl, $d4d6                                  ; $0b48: $21 $d6 $d4
    ld b, $00                                     ; $0b4b: $06 $00
    dec c                                         ; $0b4d: $0d
    add hl, bc                                    ; $0b4e: $09
    ld a, [hl]                                    ; $0b4f: $7e
    ldh [$8c], a                                  ; $0b50: $e0 $8c
    pop bc                                        ; $0b52: $c1
    pop hl                                        ; $0b53: $e1
    ret                                           ; $0b54: $c9


jr_000_0b55:
    dec b                                         ; $0b55: $05
    jr nz, jr_000_0b3a                            ; $0b56: $20 $e2

jr_000_0b58:
    ld a, $35                                     ; $0b58: $3e $35
    call Call_000_3e8a                            ; $0b5a: $cd $8a $3e
    ld hl, $d537                                  ; $0b5d: $21 $37 $d5
    ld b, $03                                     ; $0b60: $06 $03
    ld d, $20                                     ; $0b62: $16 $20

jr_000_0b64:
    ld a, [hl+]                                   ; $0b64: $2a
    cp c                                          ; $0b65: $b9
    jr z, jr_000_0b6d                             ; $0b66: $28 $05

    dec b                                         ; $0b68: $05
    jr nz, jr_000_0b64                            ; $0b69: $20 $f9

Call_000_0b6b:
    ld d, $10                                     ; $0b6b: $16 $10

Call_000_0b6d:
jr_000_0b6d:
    ld bc, $3c40                                  ; $0b6d: $01 $40 $3c
    ld a, [$c109]                                 ; $0b70: $fa $09 $c1
    cp $04                                        ; $0b73: $fe $04
    jr nz, jr_000_0b7e                            ; $0b75: $20 $07

    ld a, b                                       ; $0b77: $78
    sub d                                         ; $0b78: $92
    ld b, a                                       ; $0b79: $47
    ld a, $08                                     ; $0b7a: $3e $08
    jr jr_000_0b99                                ; $0b7c: $18 $1b

jr_000_0b7e:
    cp $00                                        ; $0b7e: $fe $00
    jr nz, jr_000_0b89                            ; $0b80: $20 $07

    ld a, b                                       ; $0b82: $78
    add d                                         ; $0b83: $82
    ld b, a                                       ; $0b84: $47
    ld a, $04                                     ; $0b85: $3e $04

Jump_000_0b87:
    jr jr_000_0b99                                ; $0b87: $18 $10

jr_000_0b89:
    cp $0c                                        ; $0b89: $fe $0c
    jr nz, jr_000_0b94                            ; $0b8b: $20 $07

    ld a, c                                       ; $0b8d: $79
    add d                                         ; $0b8e: $82
    ld c, a                                       ; $0b8f: $4f
    ld a, $01                                     ; $0b90: $3e $01
    jr jr_000_0b99                                ; $0b92: $18 $05

jr_000_0b94:
    ld a, c                                       ; $0b94: $79
    sub d                                         ; $0b95: $92
    ld c, a                                       ; $0b96: $4f
    ld a, $02                                     ; $0b97: $3e $02

jr_000_0b99:
    ld [$d52f], a                                 ; $0b99: $ea $2f $d5
    ld a, [$d4e6]                                 ; $0b9c: $fa $e6 $d4
    and a                                         ; $0b9f: $a7
    ret z                                         ; $0ba0: $c8

    ld hl, $c110                                  ; $0ba1: $21 $10 $c1
    ld d, a                                       ; $0ba4: $57
    ld e, $01                                     ; $0ba5: $1e $01

jr_000_0ba7:
    push hl                                       ; $0ba7: $e5
    ld a, [hl+]                                   ; $0ba8: $2a

Jump_000_0ba9:
    and a                                         ; $0ba9: $a7
    jr z, jr_000_0bbb                             ; $0baa: $28 $0f

    inc l                                         ; $0bac: $2c
    ld a, [hl+]                                   ; $0bad: $2a
    inc a                                         ; $0bae: $3c
    jr z, jr_000_0bbb                             ; $0baf: $28 $0a

    inc l                                         ; $0bb1: $2c
    ld a, [hl+]                                   ; $0bb2: $2a
    cp b                                          ; $0bb3: $b8
    jr nz, jr_000_0bbb                            ; $0bb4: $20 $05

    inc l                                         ; $0bb6: $2c
    ld a, [hl]                                    ; $0bb7: $7e
    cp c                                          ; $0bb8: $b9
    jr z, jr_000_0bc5                             ; $0bb9: $28 $0a

jr_000_0bbb:
    pop hl                                        ; $0bbb: $e1
    ld a, l                                       ; $0bbc: $7d
    add $10                                       ; $0bbd: $c6 $10
    ld l, a                                       ; $0bbf: $6f
    inc e                                         ; $0bc0: $1c
    dec d                                         ; $0bc1: $15
    jr nz, jr_000_0ba7                            ; $0bc2: $20 $e3

    ret                                           ; $0bc4: $c9


jr_000_0bc5:
    pop hl                                        ; $0bc5: $e1
    ld a, l                                       ; $0bc6: $7d
    and $f0                                       ; $0bc7: $e6 $f0
    inc a                                         ; $0bc9: $3c
    ld l, a                                       ; $0bca: $6f
    set 7, [hl]                                   ; $0bcb: $cb $fe
    ld a, e                                       ; $0bcd: $7b
    ldh [$8c], a                                  ; $0bce: $e0 $8c
    ret                                           ; $0bd0: $c9


Call_000_0bd1:
    ld a, [$d73b]                                 ; $0bd1: $fa $3b $d7
    bit 6, a                                      ; $0bd4: $cb $77
    jr nz, jr_000_0c0e                            ; $0bd6: $20 $36

    ld a, [$cd38]                                 ; $0bd8: $fa $38 $cd
    and a                                         ; $0bdb: $a7
    jr nz, jr_000_0c0e                            ; $0bdc: $20 $30

    ld a, [$d52f]                                 ; $0bde: $fa $2f $d5
    ld d, a                                       ; $0be1: $57
    ld a, [$c10c]                                 ; $0be2: $fa $0c $c1
    and d                                         ; $0be5: $a2
    jr nz, jr_000_0c00                            ; $0be6: $20 $18

    xor a                                         ; $0be8: $af

Jump_000_0be9:
    ldh [$8c], a                                  ; $0be9: $e0 $8c
    call Call_000_0b6b                            ; $0beb: $cd $6b $0b
    ldh a, [$8c]                                  ; $0bee: $f0 $8c
    and a                                         ; $0bf0: $a7
    jr nz, jr_000_0c00                            ; $0bf1: $20 $0d

    ld hl, $0c7e                                  ; $0bf3: $21 $7e $0c
    call Call_000_0c2a                            ; $0bf6: $cd $2a $0c
    jr c, jr_000_0c00                             ; $0bf9: $38 $05

    call Call_000_0c10                            ; $0bfb: $cd $10 $0c
    jr nc, jr_000_0c0e                            ; $0bfe: $30 $0e

jr_000_0c00:
    ld a, [$c02a]                                 ; $0c00: $fa $2a $c0
    cp $b4                                        ; $0c03: $fe $b4
    jr z, jr_000_0c0c                             ; $0c05: $28 $05

    ld a, $b4                                     ; $0c07: $3e $b4
    call Call_000_23ad                            ; $0c09: $cd $ad $23

jr_000_0c0c:
    scf                                           ; $0c0c: $37
    ret                                           ; $0c0d: $c9


jr_000_0c0e:
    and a                                         ; $0c0e: $a7

Jump_000_0c0f:
    ret                                           ; $0c0f: $c9


Call_000_0c10:
    ld a, $35                                     ; $0c10: $3e $35
    call Call_000_3e8a                            ; $0c12: $cd $8a $3e
    ld a, [$cfcb]                                 ; $0c15: $fa $cb $cf
    ld c, a                                       ; $0c18: $4f
    ld hl, $d535                                  ; $0c19: $21 $35 $d5
    ld a, [hl+]                                   ; $0c1c: $2a
    ld h, [hl]                                    ; $0c1d: $66
    ld l, a                                       ; $0c1e: $6f

jr_000_0c1f:
    ld a, [hl+]                                   ; $0c1f: $2a
    cp $ff                                        ; $0c20: $fe $ff
    jr z, jr_000_0c28                             ; $0c22: $28 $04

    cp c                                          ; $0c24: $b9
    ret z                                         ; $0c25: $c8

    jr jr_000_0c1f                                ; $0c26: $18 $f7

jr_000_0c28:
    scf                                           ; $0c28: $37
    ret                                           ; $0c29: $c9


Call_000_0c2a:
    push hl                                       ; $0c2a: $e5
    ld a, $35                                     ; $0c2b: $3e $35
    call Call_000_3e8a                            ; $0c2d: $cd $8a $3e
    push de                                       ; $0c30: $d5
    push bc                                       ; $0c31: $c5
    ld b, $06                                     ; $0c32: $06 $06
    ld hl, $6677                                  ; $0c34: $21 $77 $66
    call Call_000_35f3                            ; $0c37: $cd $f3 $35
    pop bc                                        ; $0c3a: $c1
    pop de                                        ; $0c3b: $d1
    pop hl                                        ; $0c3c: $e1
    and a                                         ; $0c3d: $a7
    ld a, [$d73b]                                 ; $0c3e: $fa $3b $d7
    bit 6, a                                      ; $0c41: $cb $77
    ret nz                                        ; $0c43: $c0

Call_000_0c44:
    ld a, [$c45c]                                 ; $0c44: $fa $5c $c4
    ld [$cf13], a                                 ; $0c47: $ea $13 $cf

Call_000_0c4a:
    ld a, [$cfcb]                                 ; $0c4a: $fa $cb $cf
    ld c, a                                       ; $0c4d: $4f

jr_000_0c4e:
    ld a, [$d36c]                                 ; $0c4e: $fa $6c $d3
    ld b, a                                       ; $0c51: $47
    ld a, [hl+]                                   ; $0c52: $2a
    cp $ff                                        ; $0c53: $fe $ff
    jr z, jr_000_0c7c                             ; $0c55: $28 $25

    cp b                                          ; $0c57: $b8
    jr z, jr_000_0c5e                             ; $0c58: $28 $04

    inc hl                                        ; $0c5a: $23

jr_000_0c5b:
    inc hl                                        ; $0c5b: $23
    jr jr_000_0c4e                                ; $0c5c: $18 $f0

jr_000_0c5e:
    ld a, [$cf13]                                 ; $0c5e: $fa $13 $cf
    ld b, a                                       ; $0c61: $47
    ld a, [hl]                                    ; $0c62: $7e
    cp b                                          ; $0c63: $b8
    jr z, jr_000_0c6d                             ; $0c64: $28 $07

    inc hl                                        ; $0c66: $23

Jump_000_0c67:
    ld a, [hl]                                    ; $0c67: $7e
    cp b                                          ; $0c68: $b8
    jr z, jr_000_0c74                             ; $0c69: $28 $09

    jr jr_000_0c5b                                ; $0c6b: $18 $ee

jr_000_0c6d:
    inc hl                                        ; $0c6d: $23
    ld a, [hl]                                    ; $0c6e: $7e
    cp c                                          ; $0c6f: $b9
    jr z, jr_000_0c7a                             ; $0c70: $28 $08

    jr jr_000_0c4e                                ; $0c72: $18 $da

jr_000_0c74:
    dec hl                                        ; $0c74: $2b
    ld a, [hl+]                                   ; $0c75: $2a
    cp c                                          ; $0c76: $b9
    inc hl                                        ; $0c77: $23
    jr nz, jr_000_0c4e                            ; $0c78: $20 $d4

jr_000_0c7a:
    scf                                           ; $0c7a: $37
    ret                                           ; $0c7b: $c9


jr_000_0c7c:
    and a                                         ; $0c7c: $a7
    ret                                           ; $0c7d: $c9


    ld de, $0520                                  ; $0c7e: $11 $20 $05
    ld de, $0541                                  ; $0c81: $11 $41 $05
    inc bc                                        ; $0c84: $03
    jr nc, jr_000_0cb5                            ; $0c85: $30 $2e

    ld de, $052a                                  ; $0c87: $11 $2a $05
    ld de, $2105                                  ; $0c8a: $11 $05 $21
    inc bc                                        ; $0c8d: $03
    ld d, d                                       ; $0c8e: $52
    ld l, $03                                     ; $0c8f: $2e $03
    ld d, l                                       ; $0c91: $55
    ld l, $03                                     ; $0c92: $2e $03
    ld d, [hl]                                    ; $0c94: $56
    ld l, $03                                     ; $0c95: $2e $03
    jr nz, jr_000_0cc7                            ; $0c97: $20 $2e

    inc bc                                        ; $0c99: $03
    ld e, [hl]                                    ; $0c9a: $5e
    ld l, $03                                     ; $0c9b: $2e $03
    ld e, a                                       ; $0c9d: $5f
    ld l, $ff                                     ; $0c9e: $2e $ff
    inc bc                                        ; $0ca0: $03
    inc d                                         ; $0ca1: $14
    ld l, $03                                     ; $0ca2: $2e $03
    ld c, b                                       ; $0ca4: $48
    ld l, $11                                     ; $0ca5: $2e $11
    inc d                                         ; $0ca7: $14
    dec b                                         ; $0ca8: $05
    rst $38                                       ; $0ca9: $ff

Call_000_0caa:
    ldh a, [$b8]                                  ; $0caa: $f0 $b8
    push af                                       ; $0cac: $f5
    ld a, [$d530]                                 ; $0cad: $fa $30 $d5
    ldh [$b8], a                                  ; $0cb0: $e0 $b8
    ld [$2000], a                                 ; $0cb2: $ea $00 $20

jr_000_0cb5:
    ld a, [$d364]                                 ; $0cb5: $fa $64 $d3
    ld e, a                                       ; $0cb8: $5f
    ld a, [$d365]                                 ; $0cb9: $fa $65 $d3
    ld d, a                                       ; $0cbc: $57
    ld hl, $c508                                  ; $0cbd: $21 $08 $c5
    ld b, $05                                     ; $0cc0: $06 $05

Jump_000_0cc2:
jr_000_0cc2:
    push hl                                       ; $0cc2: $e5
    push de                                       ; $0cc3: $d5
    ld c, $06                                     ; $0cc4: $0e $06

jr_000_0cc6:
    push bc                                       ; $0cc6: $c5

jr_000_0cc7:
    push de                                       ; $0cc7: $d5
    push hl                                       ; $0cc8: $e5

Call_000_0cc9:
    ld a, [de]                                    ; $0cc9: $1a
    ld c, a                                       ; $0cca: $4f
    call Call_000_0f1d                            ; $0ccb: $cd $1d $0f
    pop hl                                        ; $0cce: $e1
    pop de                                        ; $0ccf: $d1
    pop bc                                        ; $0cd0: $c1
    inc hl                                        ; $0cd1: $23
    inc hl                                        ; $0cd2: $23
    inc hl                                        ; $0cd3: $23
    inc hl                                        ; $0cd4: $23
    inc de                                        ; $0cd5: $13
    dec c                                         ; $0cd6: $0d
    jr nz, jr_000_0cc6                            ; $0cd7: $20 $ed

    pop de                                        ; $0cd9: $d1
    ld a, [$d36e]                                 ; $0cda: $fa $6e $d3
    add $06                                       ; $0cdd: $c6 $06
    add e                                         ; $0cdf: $83
    ld e, a                                       ; $0ce0: $5f
    jr nc, jr_000_0ce4                            ; $0ce1: $30 $01

    inc d                                         ; $0ce3: $14

jr_000_0ce4:
    pop hl                                        ; $0ce4: $e1
    ld a, $60                                     ; $0ce5: $3e $60
    add l                                         ; $0ce7: $85
    ld l, a                                       ; $0ce8: $6f
    jr nc, jr_000_0cec                            ; $0ce9: $30 $01

    inc h                                         ; $0ceb: $24

jr_000_0cec:
    dec b                                         ; $0cec: $05
    jr nz, jr_000_0cc2                            ; $0ced: $20 $d3

    ld hl, $c508                                  ; $0cef: $21 $08 $c5
    ld bc, $0000                                  ; $0cf2: $01 $00 $00
    ld a, [$d368]                                 ; $0cf5: $fa $68 $d3
    and a                                         ; $0cf8: $a7
    jr z, jr_000_0cff                             ; $0cf9: $28 $04

    ld bc, $0030                                  ; $0cfb: $01 $30 $00

Call_000_0cfe:
    add hl, bc                                    ; $0cfe: $09

jr_000_0cff:
    ld a, [$d369]                                 ; $0cff: $fa $69 $d3
    and a                                         ; $0d02: $a7
    jr z, jr_000_0d09                             ; $0d03: $28 $04

    ld bc, $0002                                  ; $0d05: $01 $02 $00
    add hl, bc                                    ; $0d08: $09

jr_000_0d09:
    ld de, $c3a0                                  ; $0d09: $11 $a0 $c3
    ld b, $12                                     ; $0d0c: $06 $12

jr_000_0d0e:
    ld c, $14                                     ; $0d0e: $0e $14

jr_000_0d10:
    ld a, [hl+]                                   ; $0d10: $2a
    ld [de], a                                    ; $0d11: $12
    inc de                                        ; $0d12: $13
    dec c                                         ; $0d13: $0d
    jr nz, jr_000_0d10                            ; $0d14: $20 $fa

    ld a, $04                                     ; $0d16: $3e $04
    add l                                         ; $0d18: $85
    ld l, a                                       ; $0d19: $6f
    jr nc, jr_000_0d1d                            ; $0d1a: $30 $01

    inc h                                         ; $0d1c: $24

jr_000_0d1d:
    dec b                                         ; $0d1d: $05
    jr nz, jr_000_0d0e                            ; $0d1e: $20 $ee

    pop af                                        ; $0d20: $f1
    ldh [$b8], a                                  ; $0d21: $e0 $b8
    ld [$2000], a                                 ; $0d23: $ea $00 $20
    ret                                           ; $0d26: $c9


Call_000_0d27:
Jump_000_0d27:
    ld a, [$c103]                                 ; $0d27: $fa $03 $c1
    ld b, a                                       ; $0d2a: $47
    ld a, [$c105]                                 ; $0d2b: $fa $05 $c1
    ld c, a                                       ; $0d2e: $4f
    ld hl, $cfca                                  ; $0d2f: $21 $ca $cf
    dec [hl]                                      ; $0d32: $35
    jr nz, jr_000_0d43                            ; $0d33: $20 $0e

    ld a, [$d366]                                 ; $0d35: $fa $66 $d3
    add b                                         ; $0d38: $80
    ld [$d366], a                                 ; $0d39: $ea $66 $d3
    ld a, [$d367]                                 ; $0d3c: $fa $67 $d3
    add c                                         ; $0d3f: $81
    ld [$d367], a                                 ; $0d40: $ea $67 $d3

jr_000_0d43:
    ld a, [$cfca]                                 ; $0d43: $fa $ca $cf
    cp $07                                        ; $0d46: $fe $07
    jp nz, Jump_000_0e36                          ; $0d48: $c2 $36 $0e

    ld a, c                                       ; $0d4b: $79
    cp $01                                        ; $0d4c: $fe $01
    jr nz, jr_000_0d62                            ; $0d4e: $20 $12

    ld a, [$d52b]                                 ; $0d50: $fa $2b $d5
    ld e, a                                       ; $0d53: $5f
    and $e0                                       ; $0d54: $e6 $e0
    ld d, a                                       ; $0d56: $57
    ld a, e                                       ; $0d57: $7b
    add $02                                       ; $0d58: $c6 $02
    and $1f                                       ; $0d5a: $e6 $1f
    or d                                          ; $0d5c: $b2
    ld [$d52b], a                                 ; $0d5d: $ea $2b $d5
    jr jr_000_0dad                                ; $0d60: $18 $4b

jr_000_0d62:
    cp $ff                                        ; $0d62: $fe $ff
    jr nz, jr_000_0d78                            ; $0d64: $20 $12

Jump_000_0d66:
    ld a, [$d52b]                                 ; $0d66: $fa $2b $d5
    ld e, a                                       ; $0d69: $5f
    and $e0                                       ; $0d6a: $e6 $e0
    ld d, a                                       ; $0d6c: $57
    ld a, e                                       ; $0d6d: $7b
    sub $02                                       ; $0d6e: $d6 $02
    and $1f                                       ; $0d70: $e6 $1f
    or d                                          ; $0d72: $b2
    ld [$d52b], a                                 ; $0d73: $ea $2b $d5
    jr jr_000_0dad                                ; $0d76: $18 $35

jr_000_0d78:
    ld a, b                                       ; $0d78: $78
    cp $01                                        ; $0d79: $fe $01
    jr nz, jr_000_0d94                            ; $0d7b: $20 $17

    ld a, [$d52b]                                 ; $0d7d: $fa $2b $d5
    add $40                                       ; $0d80: $c6 $40
    ld [$d52b], a                                 ; $0d82: $ea $2b $d5
    jr nc, jr_000_0dad                            ; $0d85: $30 $26

    ld a, [$d52c]                                 ; $0d87: $fa $2c $d5
    inc a                                         ; $0d8a: $3c
    and $03                                       ; $0d8b: $e6 $03
    or $98                                        ; $0d8d: $f6 $98
    ld [$d52c], a                                 ; $0d8f: $ea $2c $d5
    jr jr_000_0dad                                ; $0d92: $18 $19

jr_000_0d94:
    cp $ff                                        ; $0d94: $fe $ff
    jr nz, jr_000_0dad                            ; $0d96: $20 $15

    ld a, [$d52b]                                 ; $0d98: $fa $2b $d5
    sub $40                                       ; $0d9b: $d6 $40
    ld [$d52b], a                                 ; $0d9d: $ea $2b $d5
    jr nc, jr_000_0dad                            ; $0da0: $30 $0b

    ld a, [$d52c]                                 ; $0da2: $fa $2c $d5
    dec a                                         ; $0da5: $3d
    and $03                                       ; $0da6: $e6 $03
    or $98                                        ; $0da8: $f6 $98
    ld [$d52c], a                                 ; $0daa: $ea $2c $d5

jr_000_0dad:
    ld a, c                                       ; $0dad: $79
    and a                                         ; $0dae: $a7
    jr z, jr_000_0db1                             ; $0daf: $28 $00

jr_000_0db1:
    ld hl, $d369                                  ; $0db1: $21 $69 $d3
    ld a, [hl]                                    ; $0db4: $7e
    add c                                         ; $0db5: $81
    ld [hl], a                                    ; $0db6: $77
    cp $02                                        ; $0db7: $fe $02
    jr nz, jr_000_0dc9                            ; $0db9: $20 $0e

    xor a                                         ; $0dbb: $af
    ld [hl], a                                    ; $0dbc: $77
    ld hl, $d4e8                                  ; $0dbd: $21 $e8 $d4
    inc [hl]                                      ; $0dc0: $34
    ld de, $d364                                  ; $0dc1: $11 $64 $d3
    call Call_000_0e65                            ; $0dc4: $cd $65 $0e
    jr jr_000_0e0b                                ; $0dc7: $18 $42

jr_000_0dc9:
    cp $ff                                        ; $0dc9: $fe $ff
    jr nz, jr_000_0ddc                            ; $0dcb: $20 $0f

    ld a, $01                                     ; $0dcd: $3e $01
    ld [hl], a                                    ; $0dcf: $77
    ld hl, $d4e8                                  ; $0dd0: $21 $e8 $d4
    dec [hl]                                      ; $0dd3: $35
    ld de, $d364                                  ; $0dd4: $11 $64 $d3
    call Call_000_0e6f                            ; $0dd7: $cd $6f $0e
    jr jr_000_0e0b                                ; $0dda: $18 $2f

jr_000_0ddc:
    ld hl, $d368                                  ; $0ddc: $21 $68 $d3
    ld a, [hl]                                    ; $0ddf: $7e
    add b                                         ; $0de0: $80
    ld [hl], a                                    ; $0de1: $77
    cp $02                                        ; $0de2: $fe $02
    jr nz, jr_000_0df7                            ; $0de4: $20 $11

    xor a                                         ; $0de6: $af
    ld [hl], a                                    ; $0de7: $77
    ld hl, $d4e7                                  ; $0de8: $21 $e7 $d4
    inc [hl]                                      ; $0deb: $34
    ld de, $d364                                  ; $0dec: $11 $64 $d3
    ld a, [$d36e]                                 ; $0def: $fa $6e $d3
    call Call_000_0e79                            ; $0df2: $cd $79 $0e
    jr jr_000_0e0b                                ; $0df5: $18 $14

jr_000_0df7:
    cp $ff                                        ; $0df7: $fe $ff
    jr nz, jr_000_0e0b                            ; $0df9: $20 $10

Jump_000_0dfb:
    ld a, $01                                     ; $0dfb: $3e $01
    ld [hl], a                                    ; $0dfd: $77

Call_000_0dfe:
    ld hl, $d4e7                                  ; $0dfe: $21 $e7 $d4
    dec [hl]                                      ; $0e01: $35
    ld de, $d364                                  ; $0e02: $11 $64 $d3
    ld a, [$d36e]                                 ; $0e05: $fa $6e $d3
    call Call_000_0e85                            ; $0e08: $cd $85 $0e

jr_000_0e0b:
    call Call_000_0caa                            ; $0e0b: $cd $aa $0c
    ld a, [$c103]                                 ; $0e0e: $fa $03 $c1
    cp $01                                        ; $0e11: $fe $01
    jr nz, jr_000_0e1a                            ; $0e13: $20 $05

    call Call_000_0eb2                            ; $0e15: $cd $b2 $0e
    jr jr_000_0e36                                ; $0e18: $18 $1c

jr_000_0e1a:
    cp $ff                                        ; $0e1a: $fe $ff
    jr nz, jr_000_0e23                            ; $0e1c: $20 $05

    call Call_000_0e91                            ; $0e1e: $cd $91 $0e
    jr jr_000_0e36                                ; $0e21: $18 $13

jr_000_0e23:
    ld a, [$c105]                                 ; $0e23: $fa $05 $c1
    cp $01                                        ; $0e26: $fe $01
    jr nz, jr_000_0e2f                            ; $0e28: $20 $05

    call Call_000_0ed3                            ; $0e2a: $cd $d3 $0e
    jr jr_000_0e36                                ; $0e2d: $18 $07

jr_000_0e2f:
    cp $ff                                        ; $0e2f: $fe $ff
    jr nz, jr_000_0e36                            ; $0e31: $20 $03

    call Call_000_0f08                            ; $0e33: $cd $08 $0f

Jump_000_0e36:
jr_000_0e36:
    ld a, [$c103]                                 ; $0e36: $fa $03 $c1
    ld b, a                                       ; $0e39: $47

Jump_000_0e3a:
    ld a, [$c105]                                 ; $0e3a: $fa $05 $c1
    ld c, a                                       ; $0e3d: $4f
    sla b                                         ; $0e3e: $cb $20
    sla c                                         ; $0e40: $cb $21
    ldh a, [$af]                                  ; $0e42: $f0 $af
    add b                                         ; $0e44: $80
    ldh [$af], a                                  ; $0e45: $e0 $af

Call_000_0e47:
    ldh a, [$ae]                                  ; $0e47: $f0 $ae
    add c                                         ; $0e49: $81
    ldh [$ae], a                                  ; $0e4a: $e0 $ae
    ld hl, $c114                                  ; $0e4c: $21 $14 $c1
    ld a, [$d4e6]                                 ; $0e4f: $fa $e6 $d4
    and a                                         ; $0e52: $a7
    jr z, jr_000_0e64                             ; $0e53: $28 $0f

    ld e, a                                       ; $0e55: $5f

jr_000_0e56:
    ld a, [hl]                                    ; $0e56: $7e
    sub b                                         ; $0e57: $90
    ld [hl+], a                                   ; $0e58: $22
    inc l                                         ; $0e59: $2c
    ld a, [hl]                                    ; $0e5a: $7e
    sub c                                         ; $0e5b: $91
    ld [hl], a                                    ; $0e5c: $77
    ld a, $0e                                     ; $0e5d: $3e $0e
    add l                                         ; $0e5f: $85
    ld l, a                                       ; $0e60: $6f
    dec e                                         ; $0e61: $1d
    jr nz, jr_000_0e56                            ; $0e62: $20 $f2

jr_000_0e64:
    ret                                           ; $0e64: $c9


Call_000_0e65:
    ld a, [de]                                    ; $0e65: $1a
    add $01                                       ; $0e66: $c6 $01
    ld [de], a                                    ; $0e68: $12
    ret nc                                        ; $0e69: $d0

    inc de                                        ; $0e6a: $13
    ld a, [de]                                    ; $0e6b: $1a
    inc a                                         ; $0e6c: $3c
    ld [de], a                                    ; $0e6d: $12
    ret                                           ; $0e6e: $c9


Call_000_0e6f:
    ld a, [de]                                    ; $0e6f: $1a
    sub $01                                       ; $0e70: $d6 $01
    ld [de], a                                    ; $0e72: $12
    ret nc                                        ; $0e73: $d0

    inc de                                        ; $0e74: $13
    ld a, [de]                                    ; $0e75: $1a
    dec a                                         ; $0e76: $3d
    ld [de], a                                    ; $0e77: $12
    ret                                           ; $0e78: $c9


Call_000_0e79:
    add $06                                       ; $0e79: $c6 $06
    ld b, a                                       ; $0e7b: $47
    ld a, [de]                                    ; $0e7c: $1a
    add b                                         ; $0e7d: $80
    ld [de], a                                    ; $0e7e: $12
    ret nc                                        ; $0e7f: $d0

    inc de                                        ; $0e80: $13
    ld a, [de]                                    ; $0e81: $1a

Jump_000_0e82:
    inc a                                         ; $0e82: $3c
    ld [de], a                                    ; $0e83: $12
    ret                                           ; $0e84: $c9


Call_000_0e85:
    add $06                                       ; $0e85: $c6 $06
    ld b, a                                       ; $0e87: $47
    ld a, [de]                                    ; $0e88: $1a
    sub b                                         ; $0e89: $90
    ld [de], a                                    ; $0e8a: $12
    ret nc                                        ; $0e8b: $d0

    inc de                                        ; $0e8c: $13
    ld a, [de]                                    ; $0e8d: $1a
    dec a                                         ; $0e8e: $3d
    ld [de], a                                    ; $0e8f: $12
    ret                                           ; $0e90: $c9


Call_000_0e91:
    ld hl, $c3a0                                  ; $0e91: $21 $a0 $c3
    call Call_000_0ea6                            ; $0e94: $cd $a6 $0e
    ld a, [$d52b]                                 ; $0e97: $fa $2b $d5
    ldh [$d1], a                                  ; $0e9a: $e0 $d1
    ld a, [$d52c]                                 ; $0e9c: $fa $2c $d5
    ldh [$d2], a                                  ; $0e9f: $e0 $d2
    ld a, $02                                     ; $0ea1: $3e $02
    ldh [$d0], a                                  ; $0ea3: $e0 $d0
    ret                                           ; $0ea5: $c9


Call_000_0ea6:
    ld de, $cbfc                                  ; $0ea6: $11 $fc $cb
    ld c, $28                                     ; $0ea9: $0e $28

jr_000_0eab:
    ld a, [hl+]                                   ; $0eab: $2a
    ld [de], a                                    ; $0eac: $12
    inc de                                        ; $0ead: $13
    dec c                                         ; $0eae: $0d
    jr nz, jr_000_0eab                            ; $0eaf: $20 $fa

    ret                                           ; $0eb1: $c9


Call_000_0eb2:
    ld hl, $c4e0                                  ; $0eb2: $21 $e0 $c4
    call Call_000_0ea6                            ; $0eb5: $cd $a6 $0e
    ld a, [$d52b]                                 ; $0eb8: $fa $2b $d5
    ld l, a                                       ; $0ebb: $6f
    ld a, [$d52c]                                 ; $0ebc: $fa $2c $d5
    ld h, a                                       ; $0ebf: $67
    ld bc, $0200                                  ; $0ec0: $01 $00 $02
    add hl, bc                                    ; $0ec3: $09
    ld a, h                                       ; $0ec4: $7c
    and $03                                       ; $0ec5: $e6 $03
    or $98                                        ; $0ec7: $f6 $98
    ldh [$d2], a                                  ; $0ec9: $e0 $d2
    ld a, l                                       ; $0ecb: $7d
    ldh [$d1], a                                  ; $0ecc: $e0 $d1
    ld a, $02                                     ; $0ece: $3e $02
    ldh [$d0], a                                  ; $0ed0: $e0 $d0
    ret                                           ; $0ed2: $c9


Call_000_0ed3:
    ld hl, $c3b2                                  ; $0ed3: $21 $b2 $c3
    call Call_000_0ef2                            ; $0ed6: $cd $f2 $0e
    ld a, [$d52b]                                 ; $0ed9: $fa $2b $d5
    ld c, a                                       ; $0edc: $4f
    and $e0                                       ; $0edd: $e6 $e0
    ld b, a                                       ; $0edf: $47
    ld a, c                                       ; $0ee0: $79
    add $12                                       ; $0ee1: $c6 $12
    and $1f                                       ; $0ee3: $e6 $1f
    or b                                          ; $0ee5: $b0
    ldh [$d1], a                                  ; $0ee6: $e0 $d1
    ld a, [$d52c]                                 ; $0ee8: $fa $2c $d5
    ldh [$d2], a                                  ; $0eeb: $e0 $d2
    ld a, $01                                     ; $0eed: $3e $01
    ldh [$d0], a                                  ; $0eef: $e0 $d0
    ret                                           ; $0ef1: $c9


Call_000_0ef2:
    ld de, $cbfc                                  ; $0ef2: $11 $fc $cb
    ld c, $12                                     ; $0ef5: $0e $12

jr_000_0ef7:
    ld a, [hl+]                                   ; $0ef7: $2a
    ld [de], a                                    ; $0ef8: $12
    inc de                                        ; $0ef9: $13
    ld a, [hl]                                    ; $0efa: $7e

Jump_000_0efb:
    ld [de], a                                    ; $0efb: $12
    inc de                                        ; $0efc: $13
    ld a, $13                                     ; $0efd: $3e $13
    add l                                         ; $0eff: $85

Call_000_0f00:
Jump_000_0f00:
    ld l, a                                       ; $0f00: $6f

Jump_000_0f01:
    jr nc, jr_000_0f04                            ; $0f01: $30 $01

Jump_000_0f03:
    inc h                                         ; $0f03: $24

Jump_000_0f04:
jr_000_0f04:
    dec c                                         ; $0f04: $0d
    jr nz, jr_000_0ef7                            ; $0f05: $20 $f0

    ret                                           ; $0f07: $c9


Call_000_0f08:
    ld hl, $c3a0                                  ; $0f08: $21 $a0 $c3
    call Call_000_0ef2                            ; $0f0b: $cd $f2 $0e
    ld a, [$d52b]                                 ; $0f0e: $fa $2b $d5
    ldh [$d1], a                                  ; $0f11: $e0 $d1
    ld a, [$d52c]                                 ; $0f13: $fa $2c $d5
    ldh [$d2], a                                  ; $0f16: $e0 $d2
    ld a, $01                                     ; $0f18: $3e $01
    ldh [$d0], a                                  ; $0f1a: $e0 $d0
    ret                                           ; $0f1c: $c9


Call_000_0f1d:
    push hl                                       ; $0f1d: $e5
    ld a, [$d531]                                 ; $0f1e: $fa $31 $d5
    ld l, a                                       ; $0f21: $6f
    ld a, [$d532]                                 ; $0f22: $fa $32 $d5
    ld h, a                                       ; $0f25: $67
    ld a, c                                       ; $0f26: $79
    swap a                                        ; $0f27: $cb $37
    ld b, a                                       ; $0f29: $47
    and $f0                                       ; $0f2a: $e6 $f0
    ld c, a                                       ; $0f2c: $4f
    ld a, b                                       ; $0f2d: $78
    and $0f                                       ; $0f2e: $e6 $0f
    ld b, a                                       ; $0f30: $47
    add hl, bc                                    ; $0f31: $09
    ld d, h                                       ; $0f32: $54
    ld e, l                                       ; $0f33: $5d
    pop hl                                        ; $0f34: $e1
    ld c, $04                                     ; $0f35: $0e $04

jr_000_0f37:
    push bc                                       ; $0f37: $c5
    ld a, [de]                                    ; $0f38: $1a
    ld [hl+], a                                   ; $0f39: $22
    inc de                                        ; $0f3a: $13
    ld a, [de]                                    ; $0f3b: $1a
    ld [hl+], a                                   ; $0f3c: $22
    inc de                                        ; $0f3d: $13
    ld a, [de]                                    ; $0f3e: $1a
    ld [hl+], a                                   ; $0f3f: $22
    inc de                                        ; $0f40: $13
    ld a, [de]                                    ; $0f41: $1a
    ld [hl], a                                    ; $0f42: $77
    inc de                                        ; $0f43: $13
    ld bc, $0015                                  ; $0f44: $01 $15 $00
    add hl, bc                                    ; $0f47: $09

Call_000_0f48:
    pop bc                                        ; $0f48: $c1

Call_000_0f49:
    dec c                                         ; $0f49: $0d
    jr nz, jr_000_0f37                            ; $0f4a: $20 $eb

    ret                                           ; $0f4c: $c9


Call_000_0f4d:
    xor a                                         ; $0f4d: $af
    ld [$c103], a                                 ; $0f4e: $ea $03 $c1
    ld [$c105], a                                 ; $0f51: $ea $05 $c1
    call Call_000_101b                            ; $0f54: $cd $1b $10
    call Call_000_019a                            ; $0f57: $cd $9a $01
    ld a, [$d738]                                 ; $0f5a: $fa $38 $d7
    bit 3, a                                      ; $0f5d: $cb $5f
    jr nz, jr_000_0f72                            ; $0f5f: $20 $11

    ld a, [$d363]                                 ; $0f61: $fa $63 $d3
    cp $1c                                        ; $0f64: $fe $1c
    jr nz, jr_000_0f72                            ; $0f66: $20 $0a

    ldh a, [$b4]                                  ; $0f68: $f0 $b4
    and $f3                                       ; $0f6a: $e6 $f3
    jr nz, jr_000_0f72                            ; $0f6c: $20 $04

    ld a, $80                                     ; $0f6e: $3e $80
    ldh [$b4], a                                  ; $0f70: $e0 $b4

jr_000_0f72:
    ld a, [$d735]                                 ; $0f72: $fa $35 $d7
    bit 7, a                                      ; $0f75: $cb $7f
    ret z                                         ; $0f77: $c8

    ldh a, [$b4]                                  ; $0f78: $f0 $b4
    ld b, a                                       ; $0f7a: $47
    ld a, [$cd3b]                                 ; $0f7b: $fa $3b $cd
    and b                                         ; $0f7e: $a0
    ret nz                                        ; $0f7f: $c0

    ld hl, $cd38                                  ; $0f80: $21 $38 $cd
    dec [hl]                                      ; $0f83: $35

Call_000_0f84:
    ld a, [hl]                                    ; $0f84: $7e
    cp $ff                                        ; $0f85: $fe $ff
    jr z, jr_000_0f9b                             ; $0f87: $28 $12

    ld hl, $ccd3                                  ; $0f89: $21 $d3 $cc
    add l                                         ; $0f8c: $85
    ld l, a                                       ; $0f8d: $6f
    jr nc, jr_000_0f91                            ; $0f8e: $30 $01

    inc h                                         ; $0f90: $24

jr_000_0f91:
    ld a, [hl]                                    ; $0f91: $7e
    ldh [$b4], a                                  ; $0f92: $e0 $b4
    and a                                         ; $0f94: $a7
    ret nz                                        ; $0f95: $c0

    ldh [$b3], a                                  ; $0f96: $e0 $b3
    ldh [$b2], a                                  ; $0f98: $e0 $b2
    ret                                           ; $0f9a: $c9


jr_000_0f9b:
    xor a                                         ; $0f9b: $af
    ld [$cd3a], a                                 ; $0f9c: $ea $3a $cd
    ld [$cd38], a                                 ; $0f9f: $ea $38 $cd
    ld [$ccd3], a                                 ; $0fa2: $ea $d3 $cc
    ld [$cd6b], a                                 ; $0fa5: $ea $6b $cd
    ldh [$b4], a                                  ; $0fa8: $e0 $b4
    ld hl, $d73b                                  ; $0faa: $21 $3b $d7
    ld a, [hl]                                    ; $0fad: $7e
    and $f8                                       ; $0fae: $e6 $f8
    ld [hl], a                                    ; $0fb0: $77

Jump_000_0fb1:
    ld hl, $d735                                  ; $0fb1: $21 $35 $d7
    res 7, [hl]                                   ; $0fb4: $cb $be
    ret                                           ; $0fb6: $c9


Call_000_0fb7:
    ld a, [$d735]                                 ; $0fb7: $fa $35 $d7
    bit 7, a                                      ; $0fba: $cb $7f
    jp nz, Jump_000_1004                          ; $0fbc: $c2 $04 $10

    ld a, [$d52f]                                 ; $0fbf: $fa $2f $d5
    ld d, a                                       ; $0fc2: $57
    ld a, [$c10c]                                 ; $0fc3: $fa $0c $c1
    and d                                         ; $0fc6: $a2

Jump_000_0fc7:
    jr nz, jr_000_0fe5                            ; $0fc7: $20 $1c

    ld hl, $0ca0                                  ; $0fc9: $21 $a0 $0c
    call Call_000_0c2a                            ; $0fcc: $cd $2a $0c
    jr c, jr_000_0ff5                             ; $0fcf: $38 $24

Jump_000_0fd1:
    ld a, $35                                     ; $0fd1: $3e $35
    call Call_000_3e8a                            ; $0fd3: $cd $8a $3e
    ld a, [$cfcb]                                 ; $0fd6: $fa $cb $cf
    cp $14                                        ; $0fd9: $fe $14
    jr z, jr_000_1004                             ; $0fdb: $28 $27

    cp $32                                        ; $0fdd: $fe $32
    jr z, jr_000_1012                             ; $0fdf: $28 $31

    cp $48                                        ; $0fe1: $fe $48
    jr z, jr_000_1004                             ; $0fe3: $28 $1f

jr_000_0fe5:
    ld hl, $d535                                  ; $0fe5: $21 $35 $d5
    ld a, [hl+]                                   ; $0fe8: $2a
    ld h, [hl]                                    ; $0fe9: $66
    ld l, a                                       ; $0fea: $6f

jr_000_0feb:
    ld a, [hl+]                                   ; $0feb: $2a
    cp $ff                                        ; $0fec: $fe $ff
    jr z, jr_000_0ff5                             ; $0fee: $28 $05

    cp c                                          ; $0ff0: $b9
    jr z, jr_000_1006                             ; $0ff1: $28 $13

    jr jr_000_0feb                                ; $0ff3: $18 $f6

jr_000_0ff5:
    ld a, [$c02a]                                 ; $0ff5: $fa $2a $c0
    cp $b4                                        ; $0ff8: $fe $b4
    jr z, jr_000_1001                             ; $0ffa: $28 $05

Jump_000_0ffc:
    ld a, $b4                                     ; $0ffc: $3e $b4

Jump_000_0ffe:
    call Call_000_23ad                            ; $0ffe: $cd $ad $23

Call_000_1001:
jr_000_1001:
    scf                                           ; $1001: $37
    jr jr_000_1005                                ; $1002: $18 $01

Jump_000_1004:
jr_000_1004:
    and a                                         ; $1004: $a7

jr_000_1005:
    ret                                           ; $1005: $c9


jr_000_1006:
    xor a                                         ; $1006: $af
    ld [$d705], a                                 ; $1007: $ea $05 $d7
    call Call_000_0997                            ; $100a: $cd $97 $09
    call Call_000_2303                            ; $100d: $cd $03 $23
    jr jr_000_1004                                ; $1010: $18 $f2

Jump_000_1012:
jr_000_1012:
    ld a, [$d36c]                                 ; $1012: $fa $6c $d3
    cp $0e                                        ; $1015: $fe $0e
    jr nz, jr_000_1004                            ; $1017: $20 $eb

    jr jr_000_1006                                ; $1019: $18 $eb

Call_000_101b:
    push hl                                       ; $101b: $e5
    push de                                       ; $101c: $d5
    push bc                                       ; $101d: $c5
    ld b, $03                                     ; $101e: $06 $03
    ld hl, $7215                                  ; $1020: $21 $15 $72
    call Call_000_35f3                            ; $1023: $cd $f3 $35

Call_000_1026:
    ld a, [$cd60]                                 ; $1026: $fa $60 $cd
    bit 1, a                                      ; $1029: $cb $4f
    jr z, jr_000_1035                             ; $102b: $28 $08

    ld b, $03                                     ; $102d: $06 $03
    ld hl, $72a5                                  ; $102f: $21 $a5 $72
    call Call_000_35f3                            ; $1032: $cd $f3 $35

jr_000_1035:
    pop bc                                        ; $1035: $c1
    pop de                                        ; $1036: $d1
    pop hl                                        ; $1037: $e1
    call Call_000_312b                            ; $1038: $cd $2b $31

Jump_000_103b:
    ld a, [$d363]                                 ; $103b: $fa $63 $d3
    call Call_000_12bc                            ; $103e: $cd $bc $12

Jump_000_1041:
    ld hl, $d373                                  ; $1041: $21 $73 $d3
    ld a, [hl+]                                   ; $1044: $2a
    ld h, [hl]                                    ; $1045: $66
    ld l, a                                       ; $1046: $6f
    ld de, $104c                                  ; $1047: $11 $4c $10
    push de                                       ; $104a: $d5
    jp hl                                         ; $104b: $e9


Call_000_104c:
    ret                                           ; $104c: $c9


Jump_000_104d:
    ld de, $4180                                  ; $104d: $11 $80 $41
    ld hl, $8000                                  ; $1050: $21 $00 $80
    jr jr_000_1063                                ; $1053: $18 $0e

Jump_000_1055:
    ld de, $76c0                                  ; $1055: $11 $c0 $76
    ld hl, $8000                                  ; $1058: $21 $00 $80
    jr jr_000_1063                                ; $105b: $18 $06

Jump_000_105d:
    ld de, $4000                                  ; $105d: $11 $00 $40
    ld hl, $8000                                  ; $1060: $21 $00 $80

jr_000_1063:
    push de                                       ; $1063: $d5
    push hl                                       ; $1064: $e5
    ld bc, $050c                                  ; $1065: $01 $0c $05
    call Call_000_1845                            ; $1068: $cd $45 $18
    pop hl                                        ; $106b: $e1
    pop de                                        ; $106c: $d1
    ld a, $c0                                     ; $106d: $3e $c0
    add e                                         ; $106f: $83
    ld e, a                                       ; $1070: $5f
    jr nc, jr_000_1074                            ; $1071: $30 $01

    inc d                                         ; $1073: $14

jr_000_1074:
    set 3, h                                      ; $1074: $cb $dc
    ld bc, $050c                                  ; $1076: $01 $0c $05

Call_000_1079:
    jp Jump_000_1845                              ; $1079: $c3 $45 $18


Call_000_107c:
    ld b, $03                                     ; $107c: $06 $03
    ld hl, $7103                                  ; $107e: $21 $03 $71
    call Call_000_35f3                            ; $1081: $cd $f3 $35
    ld a, [$d36c]                                 ; $1084: $fa $6c $d3
    ld [$d11e], a                                 ; $1087: $ea $1e $d1
    ld a, [$d363]                                 ; $108a: $fa $63 $d3
    call Call_000_12bc                            ; $108d: $cd $bc $12
    ld a, [$d36c]                                 ; $1090: $fa $6c $d3
    ld b, a                                       ; $1093: $47
    res 7, a                                      ; $1094: $cb $bf
    ld [$d36c], a                                 ; $1096: $ea $6c $d3
    ldh [$8b], a                                  ; $1099: $e0 $8b
    bit 7, b                                      ; $109b: $cb $78
    ret nz                                        ; $109d: $c0

    ld hl, $01ae                                  ; $109e: $21 $ae $01
    ld a, [$d363]                                 ; $10a1: $fa $63 $d3
    sla a                                         ; $10a4: $cb $27
    jr nc, jr_000_10a9                            ; $10a6: $30 $01

    inc h                                         ; $10a8: $24

Call_000_10a9:
jr_000_10a9:
    add l                                         ; $10a9: $85
    ld l, a                                       ; $10aa: $6f
    jr nc, jr_000_10ae                            ; $10ab: $30 $01

Jump_000_10ad:
    inc h                                         ; $10ad: $24

jr_000_10ae:
    ld a, [hl+]                                   ; $10ae: $2a
    ld h, [hl]                                    ; $10af: $66
    ld l, a                                       ; $10b0: $6f
    ld de, $d36c                                  ; $10b1: $11 $6c $d3
    ld c, $0a                                     ; $10b4: $0e $0a

jr_000_10b6:
    ld a, [hl+]                                   ; $10b6: $2a
    ld [de], a                                    ; $10b7: $12
    inc de                                        ; $10b8: $13
    dec c                                         ; $10b9: $0d
    jr nz, jr_000_10b6                            ; $10ba: $20 $fa

    ld a, $ff                                     ; $10bc: $3e $ff
    ld [$d376], a                                 ; $10be: $ea $76 $d3
    ld [$d381], a                                 ; $10c1: $ea $81 $d3
    ld [$d38c], a                                 ; $10c4: $ea $8c $d3

Call_000_10c7:
    ld [$d397], a                                 ; $10c7: $ea $97 $d3
    ld a, [$d375]                                 ; $10ca: $fa $75 $d3
    ld b, a                                       ; $10cd: $47
    bit 3, b                                      ; $10ce: $cb $58
    jr z, jr_000_10d8                             ; $10d0: $28 $06

    ld de, $d376                                  ; $10d2: $11 $76 $d3
    call Call_000_1238                            ; $10d5: $cd $38 $12

Jump_000_10d8:
jr_000_10d8:
    bit 2, b                                      ; $10d8: $cb $50
    jr z, jr_000_10e2                             ; $10da: $28 $06

    ld de, $d381                                  ; $10dc: $11 $81 $d3
    call Call_000_1238                            ; $10df: $cd $38 $12

jr_000_10e2:
    bit 1, b                                      ; $10e2: $cb $48
    jr z, jr_000_10ec                             ; $10e4: $28 $06

    ld de, $d38c                                  ; $10e6: $11 $8c $d3
    call Call_000_1238                            ; $10e9: $cd $38 $12

jr_000_10ec:
    bit 0, b                                      ; $10ec: $cb $40
    jr z, jr_000_10f6                             ; $10ee: $28 $06

    ld de, $d397                                  ; $10f0: $11 $97 $d3
    call Call_000_1238                            ; $10f3: $cd $38 $12

jr_000_10f6:
    ld a, [hl+]                                   ; $10f6: $2a
    ld [$d3ae], a                                 ; $10f7: $ea $ae $d3
    ld a, [hl+]                                   ; $10fa: $2a
    ld [$d3af], a                                 ; $10fb: $ea $af $d3

Jump_000_10fe:
    push hl                                       ; $10fe: $e5

Call_000_10ff:
    ld a, [$d3ae]                                 ; $10ff: $fa $ae $d3
    ld l, a                                       ; $1102: $6f
    ld a, [$d3af]                                 ; $1103: $fa $af $d3
    ld h, a                                       ; $1106: $67
    ld de, $d3b2                                  ; $1107: $11 $b2 $d3
    ld a, [hl+]                                   ; $110a: $2a
    ld [de], a                                    ; $110b: $12
    ld a, [hl+]                                   ; $110c: $2a
    ld [$d3b3], a                                 ; $110d: $ea $b3 $d3
    and a                                         ; $1110: $a7
    jr z, jr_000_1122                             ; $1111: $28 $0f

    ld c, a                                       ; $1113: $4f
    ld de, $d3b4                                  ; $1114: $11 $b4 $d3

jr_000_1117:
    ld b, $04                                     ; $1117: $06 $04

jr_000_1119:
    ld a, [hl+]                                   ; $1119: $2a
    ld [de], a                                    ; $111a: $12
    inc de                                        ; $111b: $13
    dec b                                         ; $111c: $05
    jr nz, jr_000_1119                            ; $111d: $20 $fa

    dec c                                         ; $111f: $0d
    jr nz, jr_000_1117                            ; $1120: $20 $f5

jr_000_1122:
    ld a, [hl+]                                   ; $1122: $2a
    ld [$d4b5], a                                 ; $1123: $ea $b5 $d4
    and a                                         ; $1126: $a7
    jr z, jr_000_1150                             ; $1127: $28 $27

    ld c, a                                       ; $1129: $4f
    ld de, $d4d6                                  ; $112a: $11 $d6 $d4
    ld a, d                                       ; $112d: $7a
    ldh [$95], a                                  ; $112e: $e0 $95
    ld a, e                                       ; $1130: $7b
    ldh [$96], a                                  ; $1131: $e0 $96
    ld de, $d4b6                                  ; $1133: $11 $b6 $d4

jr_000_1136:
    ld a, [hl+]                                   ; $1136: $2a
    ld [de], a                                    ; $1137: $12
    inc de                                        ; $1138: $13
    ld a, [hl+]                                   ; $1139: $2a
    ld [de], a                                    ; $113a: $12
    inc de                                        ; $113b: $13
    push de                                       ; $113c: $d5
    ldh a, [$95]                                  ; $113d: $f0 $95
    ld d, a                                       ; $113f: $57
    ldh a, [$96]                                  ; $1140: $f0 $96
    ld e, a                                       ; $1142: $5f
    ld a, [hl+]                                   ; $1143: $2a

Call_000_1144:
    ld [de], a                                    ; $1144: $12
    inc de                                        ; $1145: $13
    ld a, d                                       ; $1146: $7a
    ldh [$95], a                                  ; $1147: $e0 $95

Call_000_1149:
    ld a, e                                       ; $1149: $7b
    ldh [$96], a                                  ; $114a: $e0 $96

Jump_000_114c:
    pop de                                        ; $114c: $d1
    dec c                                         ; $114d: $0d
    jr nz, jr_000_1136                            ; $114e: $20 $e6

jr_000_1150:
    ld a, [$d733]                                 ; $1150: $fa $33 $d7
    bit 5, a                                      ; $1153: $cb $6f
    jp nz, Jump_000_11f8                          ; $1155: $c2 $f8 $11

    ld a, [hl+]                                   ; $1158: $2a
    ld [$d4e6], a                                 ; $1159: $ea $e6 $d4
    push hl                                       ; $115c: $e5
    ld hl, $c110                                  ; $115d: $21 $10 $c1
    ld de, $c210                                  ; $1160: $11 $10 $c2

Call_000_1163:
    xor a                                         ; $1163: $af
    ld b, $f0                                     ; $1164: $06 $f0

jr_000_1166:
    ld [hl+], a                                   ; $1166: $22
    ld [de], a                                    ; $1167: $12
    inc e                                         ; $1168: $1c
    dec b                                         ; $1169: $05
    jr nz, jr_000_1166                            ; $116a: $20 $fa

    ld hl, $c112                                  ; $116c: $21 $12 $c1
    ld de, $0010                                  ; $116f: $11 $10 $00
    ld c, $0f                                     ; $1172: $0e $0f

jr_000_1174:
    ld [hl], $ff                                  ; $1174: $36 $ff
    add hl, de                                    ; $1176: $19
    dec c                                         ; $1177: $0d
    jr nz, jr_000_1174                            ; $1178: $20 $fa

    pop hl                                        ; $117a: $e1
    ld de, $c110                                  ; $117b: $11 $10 $c1
    ld a, [$d4e6]                                 ; $117e: $fa $e6 $d4
    and a                                         ; $1181: $a7

Call_000_1182:
Jump_000_1182:
    jp z, Jump_000_11f8                           ; $1182: $ca $f8 $11

    ld b, a                                       ; $1185: $47
    ld c, $00                                     ; $1186: $0e $00

Jump_000_1188:
    ld a, [hl+]                                   ; $1188: $2a
    ld [de], a                                    ; $1189: $12
    inc d                                         ; $118a: $14
    ld a, $04                                     ; $118b: $3e $04
    add e                                         ; $118d: $83
    ld e, a                                       ; $118e: $5f
    ld a, [hl+]                                   ; $118f: $2a
    ld [de], a                                    ; $1190: $12
    inc e                                         ; $1191: $1c
    ld a, [hl+]                                   ; $1192: $2a
    ld [de], a                                    ; $1193: $12
    inc e                                         ; $1194: $1c
    ld a, [hl+]                                   ; $1195: $2a
    ld [de], a                                    ; $1196: $12
    ld a, [hl+]                                   ; $1197: $2a
    ldh [$8d], a                                  ; $1198: $e0 $8d
    ld a, [hl+]                                   ; $119a: $2a
    ldh [$8e], a                                  ; $119b: $e0 $8e
    push bc                                       ; $119d: $c5
    push hl                                       ; $119e: $e5
    ld b, $00                                     ; $119f: $06 $00
    ld hl, $d4e9                                  ; $11a1: $21 $e9 $d4
    add hl, bc                                    ; $11a4: $09

Call_000_11a5:
    ldh a, [$8d]                                  ; $11a5: $f0 $8d
    ld [hl+], a                                   ; $11a7: $22
    ldh a, [$8e]                                  ; $11a8: $f0 $8e
    ld [hl], a                                    ; $11aa: $77
    ldh a, [$8e]                                  ; $11ab: $f0 $8e
    ldh [$8d], a                                  ; $11ad: $e0 $8d
    and $3f                                       ; $11af: $e6 $3f

Jump_000_11b1:
    ld [hl], a                                    ; $11b1: $77
    pop hl                                        ; $11b2: $e1
    ldh a, [$8d]                                  ; $11b3: $f0 $8d
    bit 6, a                                      ; $11b5: $cb $77
    jr nz, jr_000_11bf                            ; $11b7: $20 $06

    bit 7, a                                      ; $11b9: $cb $7f
    jr nz, jr_000_11d3                            ; $11bb: $20 $16

    jr jr_000_11e3                                ; $11bd: $18 $24

jr_000_11bf:
    ld a, [hl+]                                   ; $11bf: $2a
    ldh [$8d], a                                  ; $11c0: $e0 $8d
    ld a, [hl+]                                   ; $11c2: $2a
    ldh [$8e], a                                  ; $11c3: $e0 $8e
    push hl                                       ; $11c5: $e5
    ld hl, $d509                                  ; $11c6: $21 $09 $d5
    add hl, bc                                    ; $11c9: $09
    ldh a, [$8d]                                  ; $11ca: $f0 $8d
    ld [hl+], a                                   ; $11cc: $22
    ldh a, [$8e]                                  ; $11cd: $f0 $8e
    ld [hl], a                                    ; $11cf: $77
    pop hl                                        ; $11d0: $e1
    jr jr_000_11ec                                ; $11d1: $18 $19

jr_000_11d3:
    ld a, [hl+]                                   ; $11d3: $2a
    ldh [$8d], a                                  ; $11d4: $e0 $8d
    push hl                                       ; $11d6: $e5
    ld hl, $d509                                  ; $11d7: $21 $09 $d5
    add hl, bc                                    ; $11da: $09
    ldh a, [$8d]                                  ; $11db: $f0 $8d

Jump_000_11dd:
    ld [hl+], a                                   ; $11dd: $22
    xor a                                         ; $11de: $af
    ld [hl], a                                    ; $11df: $77
    pop hl                                        ; $11e0: $e1
    jr jr_000_11ec                                ; $11e1: $18 $09

jr_000_11e3:
    push hl                                       ; $11e3: $e5
    ld hl, $d509                                  ; $11e4: $21 $09 $d5
    add hl, bc                                    ; $11e7: $09
    xor a                                         ; $11e8: $af
    ld [hl+], a                                   ; $11e9: $22
    ld [hl], a                                    ; $11ea: $77
    pop hl                                        ; $11eb: $e1

jr_000_11ec:
    pop bc                                        ; $11ec: $c1
    dec d                                         ; $11ed: $15
    ld a, $0a                                     ; $11ee: $3e $0a
    add e                                         ; $11f0: $83
    ld e, a                                       ; $11f1: $5f

Call_000_11f2:
    inc c                                         ; $11f2: $0c
    inc c                                         ; $11f3: $0c
    dec b                                         ; $11f4: $05
    jp nz, Jump_000_1188                          ; $11f5: $c2 $88 $11

Jump_000_11f8:
    ld a, $19                                     ; $11f8: $3e $19
    call Call_000_3e8a                            ; $11fa: $cd $8a $3e
    ld hl, $4eb8                                  ; $11fd: $21 $b8 $4e

Call_000_1200:
Jump_000_1200:
    ld b, $03                                     ; $1200: $06 $03
    call Call_000_35f3                            ; $1202: $cd $f3 $35

Jump_000_1205:
    pop hl                                        ; $1205: $e1
    ld a, [$d36d]                                 ; $1206: $fa $6d $d3
    add a                                         ; $1209: $87

Jump_000_120a:
    ld [$d529], a                                 ; $120a: $ea $29 $d5

Jump_000_120d:
    ld a, [$d36e]                                 ; $120d: $fa $6e $d3
    add a                                         ; $1210: $87
    ld [$d52a], a                                 ; $1211: $ea $2a $d5

Jump_000_1214:
    ld a, [$d363]                                 ; $1214: $fa $63 $d3

Jump_000_1217:
    ld c, a                                       ; $1217: $4f
    ld b, $00                                     ; $1218: $06 $00
    ldh a, [$b8]                                  ; $121a: $f0 $b8
    push af                                       ; $121c: $f5
    ld a, $03                                     ; $121d: $3e $03
    ldh [$b8], a                                  ; $121f: $e0 $b8
    ld [$2000], a                                 ; $1221: $ea $00 $20
    ld hl, $404d                                  ; $1224: $21 $4d $40
    add hl, bc                                    ; $1227: $09
    add hl, bc                                    ; $1228: $09
    ld a, [hl+]                                   ; $1229: $2a
    ld [$d360], a                                 ; $122a: $ea $60 $d3
    ld a, [hl]                                    ; $122d: $7e
    ld [$d361], a                                 ; $122e: $ea $61 $d3
    pop af                                        ; $1231: $f1
    ldh [$b8], a                                  ; $1232: $e0 $b8
    ld [$2000], a                                 ; $1234: $ea $00 $20
    ret                                           ; $1237: $c9


Call_000_1238:
    ld c, $0b                                     ; $1238: $0e $0b

jr_000_123a:
    ld a, [hl+]                                   ; $123a: $2a
    ld [de], a                                    ; $123b: $12
    inc de                                        ; $123c: $13

Jump_000_123d:
    dec c                                         ; $123d: $0d
    jr nz, jr_000_123a                            ; $123e: $20 $fa

    ret                                           ; $1240: $c9


Call_000_1241:
    ldh a, [$b8]                                  ; $1241: $f0 $b8
    push af                                       ; $1243: $f5
    call Call_000_0061                            ; $1244: $cd $61 $00
    ld a, $98                                     ; $1247: $3e $98
    ld [$d52c], a                                 ; $1249: $ea $2c $d5

Jump_000_124c:
    xor a                                         ; $124c: $af
    ld [$d52b], a                                 ; $124d: $ea $2b $d5
    ldh [$af], a                                  ; $1250: $e0 $af

Jump_000_1252:
    ldh [$ae], a                                  ; $1252: $e0 $ae
    ld [$cfca], a                                 ; $1254: $ea $ca $cf
    ld [$d11e], a                                 ; $1257: $ea $1e $d1
    ld [$d11f], a                                 ; $125a: $ea $1f $d1
    ld [$d3ad], a                                 ; $125d: $ea $ad $d3
    call Call_000_36bd                            ; $1260: $cd $bd $36
    call Call_000_107c                            ; $1263: $cd $7c $10
    ld b, $05                                     ; $1266: $06 $05
    ld hl, $785b                                  ; $1268: $21 $5b $78
    call Call_000_35f3                            ; $126b: $cd $f3 $35
    call Call_000_09fc                            ; $126e: $cd $fc $09
    call Call_000_09e8                            ; $1271: $cd $e8 $09

Call_000_1274:
    call Call_000_0caa                            ; $1274: $cd $aa $0c
    ld hl, $c3a0                                  ; $1277: $21 $a0 $c3
    ld de, $9800                                  ; $127a: $11 $00 $98
    ld b, $12                                     ; $127d: $06 $12

jr_000_127f:
    ld c, $14                                     ; $127f: $0e $14

jr_000_1281:
    ld a, [hl+]                                   ; $1281: $2a
    ld [de], a                                    ; $1282: $12
    inc e                                         ; $1283: $1c
    dec c                                         ; $1284: $0d
    jr nz, jr_000_1281                            ; $1285: $20 $fa

    ld a, $0c                                     ; $1287: $3e $0c
    add e                                         ; $1289: $83
    ld e, a                                       ; $128a: $5f
    jr nc, jr_000_128e                            ; $128b: $30 $01

    inc d                                         ; $128d: $14

jr_000_128e:
    dec b                                         ; $128e: $05
    jr nz, jr_000_127f                            ; $128f: $20 $ee

    ld a, $01                                     ; $1291: $3e $01
    ld [$cfd0], a                                 ; $1293: $ea $d0 $cf
    call Call_000_007b                            ; $1296: $cd $7b $00
    ld b, $09                                     ; $1299: $06 $09
    call Call_000_3e0c                            ; $129b: $cd $0c $3e
    call Call_000_0997                            ; $129e: $cd $97 $09
    ld a, [$d737]                                 ; $12a1: $fa $37 $d7
    and $18                                       ; $12a4: $e6 $18

Call_000_12a6:
    jr nz, jr_000_12b5                            ; $12a6: $20 $0d

    ld a, [$d738]                                 ; $12a8: $fa $38 $d7
    bit 1, a                                      ; $12ab: $cb $4f
    jr nz, jr_000_12b5                            ; $12ad: $20 $06

    call Call_000_235b                            ; $12af: $cd $5b $23
    call Call_000_230e                            ; $12b2: $cd $0e $23

jr_000_12b5:
    pop af                                        ; $12b5: $f1
    ldh [$b8], a                                  ; $12b6: $e0 $b8
    ld [$2000], a                                 ; $12b8: $ea $00 $20
    ret                                           ; $12bb: $c9


Call_000_12bc:
    push hl                                       ; $12bc: $e5
    push bc                                       ; $12bd: $c5

Call_000_12be:
    ld c, a                                       ; $12be: $4f
    ld b, $00                                     ; $12bf: $06 $00
    ld a, $03                                     ; $12c1: $3e $03
    call Call_000_35d9                            ; $12c3: $cd $d9 $35
    ld hl, $423d                                  ; $12c6: $21 $3d $42
    add hl, bc                                    ; $12c9: $09
    ld a, [hl]                                    ; $12ca: $7e
    ldh [$e8], a                                  ; $12cb: $e0 $e8
    call Call_000_35ea                            ; $12cd: $cd $ea $35
    ldh a, [$e8]                                  ; $12d0: $f0 $e8
    ldh [$b8], a                                  ; $12d2: $e0 $b8
    ld [$2000], a                                 ; $12d4: $ea $00 $20
    pop bc                                        ; $12d7: $c1
    pop hl                                        ; $12d8: $e1
    ret                                           ; $12d9: $c9


Call_000_12da:
    ld a, $1e                                     ; $12da: $3e $1e
    ld [$d13f], a                                 ; $12dc: $ea $3f $d1
    ld hl, $d735                                  ; $12df: $21 $35 $d7
    ld a, [hl]                                    ; $12e2: $7e
    or $26                                        ; $12e3: $f6 $26
    ld [hl], a                                    ; $12e5: $77

Call_000_12e6:
    ret                                           ; $12e6: $c9


Call_000_12e7:
    ld hl, $d72d                                  ; $12e7: $21 $2d $d7
    res 0, [hl]                                   ; $12ea: $cb $86
    ret                                           ; $12ec: $c9


Jump_000_12ed:
    ld b, $05                                     ; $12ed: $06 $05
    ld hl, $0997                                  ; $12ef: $21 $97 $09

Call_000_12f2:
    call Call_000_35f3                            ; $12f2: $cd $f3 $35
    jp Jump_000_2303                              ; $12f5: $c3 $03 $23


Call_000_12f8:
jr_000_12f8:
    call Call_000_20ab                            ; $12f8: $cd $ab $20
    push bc                                       ; $12fb: $c5
    call Call_000_384e                            ; $12fc: $cd $4e $38
    pop bc                                        ; $12ff: $c1
    ldh a, [$b4]                                  ; $1300: $f0 $b4
    cp $46                                        ; $1302: $fe $46

Call_000_1304:
    jr z, jr_000_1311                             ; $1304: $28 $0b

Call_000_1306:
Jump_000_1306:
    ldh a, [$b5]                                  ; $1306: $f0 $b5
    and $09                                       ; $1308: $e6 $09
    jr nz, jr_000_1311                            ; $130a: $20 $05

    dec c                                         ; $130c: $0d
    jr nz, jr_000_12f8                            ; $130d: $20 $e9

    and a                                         ; $130f: $a7
    ret                                           ; $1310: $c9


jr_000_1311:
    scf                                           ; $1311: $37
    ret                                           ; $1312: $c9


Call_000_1313:
    ld b, a                                       ; $1313: $47
    ldh a, [$b8]                                  ; $1314: $f0 $b8
    push af                                       ; $1316: $f5
    ld a, [$cf17]                                 ; $1317: $fa $17 $cf
    ldh [$b8], a                                  ; $131a: $e0 $b8
    ld [$2000], a                                 ; $131c: $ea $00 $20
    ld a, b                                       ; $131f: $78
    add a                                         ; $1320: $87
    add a                                         ; $1321: $87
    ld c, a                                       ; $1322: $4f
    ld b, $00                                     ; $1323: $06 $00
    add hl, bc                                    ; $1325: $09
    ld bc, $0004                                  ; $1326: $01 $04 $00
    ld de, $d364                                  ; $1329: $11 $64 $d3
    call Call_000_00b5                            ; $132c: $cd $b5 $00
    pop af                                        ; $132f: $f1
    ldh [$b8], a                                  ; $1330: $e0 $b8
    ld [$2000], a                                 ; $1332: $ea $00 $20
    ret                                           ; $1335: $c9


Call_000_1336:
    push hl                                       ; $1336: $e5
    push de                                       ; $1337: $d5
    push bc                                       ; $1338: $c5
    ld a, $71                                     ; $1339: $3e $71
    ld [hl+], a                                   ; $133b: $22
    ld a, $62                                     ; $133c: $3e $62
    ld [hl+], a                                   ; $133e: $22
    push hl                                       ; $133f: $e5
    ld a, $63                                     ; $1340: $3e $63

Jump_000_1342:
jr_000_1342:
    ld [hl+], a                                   ; $1342: $22
    dec d                                         ; $1343: $15

Jump_000_1344:
    jr nz, jr_000_1342                            ; $1344: $20 $fc

    ld a, [$cf99]                                 ; $1346: $fa $99 $cf
    dec a                                         ; $1349: $3d
    ld a, $6d                                     ; $134a: $3e $6d
    jr z, jr_000_134f                             ; $134c: $28 $01

    dec a                                         ; $134e: $3d

jr_000_134f:
    ld [hl], a                                    ; $134f: $77
    pop hl                                        ; $1350: $e1
    ld a, e                                       ; $1351: $7b
    and a                                         ; $1352: $a7
    jr nz, jr_000_135b                            ; $1353: $20 $06

Call_000_1355:
    ld a, c                                       ; $1355: $79
    and a                                         ; $1356: $a7
    jr z, jr_000_136e                             ; $1357: $28 $15

    ld e, $01                                     ; $1359: $1e $01

jr_000_135b:
    ld a, e                                       ; $135b: $7b
    sub $08                                       ; $135c: $d6 $08
    jr c, jr_000_136a                             ; $135e: $38 $0a

    ld e, a                                       ; $1360: $5f

Call_000_1361:
    ld a, $6b                                     ; $1361: $3e $6b
    ld [hl+], a                                   ; $1363: $22
    ld a, e                                       ; $1364: $7b
    and a                                         ; $1365: $a7
    jr z, jr_000_136e                             ; $1366: $28 $06

    jr jr_000_135b                                ; $1368: $18 $f1

jr_000_136a:
    ld a, $63                                     ; $136a: $3e $63
    add e                                         ; $136c: $83
    ld [hl], a                                    ; $136d: $77

jr_000_136e:
    pop bc                                        ; $136e: $c1
    pop de                                        ; $136f: $d1
    pop hl                                        ; $1370: $e1

Call_000_1371:
    ret                                           ; $1371: $c9


Call_000_1372:
    ld hl, $45b8                                  ; $1372: $21 $b8 $45
    ld b, $01                                     ; $1375: $06 $01
    jp Jump_000_35f3                              ; $1377: $c3 $f3 $35


    ld hl, $d0e1                                  ; $137a: $21 $e1 $d0
    ld e, b                                       ; $137d: $58
    ld d, $00                                     ; $137e: $16 $00
    add hl, de                                    ; $1380: $19
    ld a, c                                       ; $1381: $79
    ld [hl], a                                    ; $1382: $77
    ret                                           ; $1383: $c9


Call_000_1384:
Jump_000_1384:
    ld a, $01                                     ; $1384: $3e $01
    ld [$d0af], a                                 ; $1386: $ea $af $d0

Call_000_1389:
Jump_000_1389:
    push hl                                       ; $1389: $e5
    ld a, [$d123]                                 ; $138a: $fa $23 $d1
    push af                                       ; $138d: $f5
    ld a, [$cf96]                                 ; $138e: $fa $96 $cf
    ld [$d123], a                                 ; $1391: $ea $23 $d1
    ld a, $3a                                     ; $1394: $3e $3a
    call Call_000_3e8a                            ; $1396: $cd $8a $3e
    ld hl, $d123                                  ; $1399: $21 $23 $d1
    ld a, [hl]                                    ; $139c: $7e
    pop bc                                        ; $139d: $c1
    ld [hl], b                                    ; $139e: $70
    and a                                         ; $139f: $a7
    pop hl                                        ; $13a0: $e1
    jr z, jr_000_13a7                             ; $13a1: $28 $04

    cp $98                                        ; $13a3: $fe $98

Call_000_13a5:
    jr c, jr_000_13ad                             ; $13a5: $38 $06

jr_000_13a7:
    ld a, $01                                     ; $13a7: $3e $01

Call_000_13a9:
    ld [$cf96], a                                 ; $13a9: $ea $96 $cf
    ret                                           ; $13ac: $c9


jr_000_13ad:
    push hl                                       ; $13ad: $e5
    ld de, $9000                                  ; $13ae: $11 $00 $90
    call Call_000_1662                            ; $13b1: $cd $62 $16
    pop hl                                        ; $13b4: $e1

Call_000_13b5:
    ldh a, [$b8]                                  ; $13b5: $f0 $b8
    push af                                       ; $13b7: $f5
    ld a, $0f                                     ; $13b8: $3e $0f
    ldh [$b8], a                                  ; $13ba: $e0 $b8
    ld [$2000], a                                 ; $13bc: $ea $00 $20
    xor a                                         ; $13bf: $af
    ldh [$e1], a                                  ; $13c0: $e0 $e1
    call $70eb                                    ; $13c2: $cd $eb $70
    xor a                                         ; $13c5: $af
    ld [$d0af], a                                 ; $13c6: $ea $af $d0
    pop af                                        ; $13c9: $f1
    ldh [$b8], a                                  ; $13ca: $e0 $b8
    ld [$2000], a                                 ; $13cc: $ea $00 $20
    ret                                           ; $13cf: $c9


Call_000_13d0:
Jump_000_13d0:
    call Call_000_13d9                            ; $13d0: $cd $d9 $13
    call Call_000_23ad                            ; $13d3: $cd $ad $23
    jp Jump_000_3765                              ; $13d6: $c3 $65 $37


Call_000_13d9:
    dec a                                         ; $13d9: $3d
    ld c, a                                       ; $13da: $4f
    ld b, $00                                     ; $13db: $06 $00
    ld hl, $5446                                  ; $13dd: $21 $46 $54
    add hl, bc                                    ; $13e0: $09
    add hl, bc                                    ; $13e1: $09
    add hl, bc                                    ; $13e2: $09
    ld a, $0e                                     ; $13e3: $3e $0e
    call Call_000_35d9                            ; $13e5: $cd $d9 $35
    ld a, [hl+]                                   ; $13e8: $2a
    ld b, a                                       ; $13e9: $47
    ld a, [hl+]                                   ; $13ea: $2a
    ld [$c0f1], a                                 ; $13eb: $ea $f1 $c0
    ld a, [hl]                                    ; $13ee: $7e
    ld [$c0f2], a                                 ; $13ef: $ea $f2 $c0

Call_000_13f2:
    call Call_000_35ea                            ; $13f2: $cd $ea $35
    ld a, b                                       ; $13f5: $78
    ld c, $14                                     ; $13f6: $0e $14
    rlca                                          ; $13f8: $07
    add b                                         ; $13f9: $80
    add c                                         ; $13fa: $81
    ret                                           ; $13fb: $c9


Call_000_13fc:
    ldh a, [$d7]                                  ; $13fc: $f0 $d7
    push af                                       ; $13fe: $f5

Call_000_13ff:
    xor a                                         ; $13ff: $af
    ldh [$d7], a                                  ; $1400: $e0 $d7
    call Call_000_3df1                            ; $1402: $cd $f1 $3d
    call Call_000_0082                            ; $1405: $cd $82 $00
    call Call_000_1420                            ; $1408: $cd $20 $14
    call Call_000_14d4                            ; $140b: $cd $d4 $14
    jp Jump_000_145a                              ; $140e: $c3 $5a $14


Call_000_1411:
    ldh a, [$d7]                                  ; $1411: $f0 $d7
    push af                                       ; $1413: $f5
    xor a                                         ; $1414: $af

Call_000_1415:
    ldh [$d7], a                                  ; $1415: $e0 $d7
    call Call_000_1420                            ; $1417: $cd $20 $14
    call Call_000_14d9                            ; $141a: $cd $d9 $14
    jp Jump_000_145a                              ; $141d: $c3 $5a $14


Call_000_1420:
    ld a, $01                                     ; $1420: $3e $01
    call Call_000_35d9                            ; $1422: $cd $d9 $35
    call Call_000_36dd                            ; $1425: $cd $dd $36
    ld hl, $d735                                  ; $1428: $21 $35 $d7
    set 6, [hl]                                   ; $142b: $cb $f6
    xor a                                         ; $142d: $af
    ld [$cc49], a                                 ; $142e: $ea $49 $cc
    ld [$cc37], a                                 ; $1431: $ea $37 $cc
    ld hl, $cc24                                  ; $1434: $21 $24 $cc
    inc a                                         ; $1437: $3c
    ld [hl+], a                                   ; $1438: $22
    xor a                                         ; $1439: $af
    ld [hl+], a                                   ; $143a: $22
    ld a, [$cc2b]                                 ; $143b: $fa $2b $cc
    push af                                       ; $143e: $f5
    ld [hl+], a                                   ; $143f: $22
    inc hl                                        ; $1440: $23

Jump_000_1441:
    ld a, [$d168]                                 ; $1441: $fa $68 $d1
    and a                                         ; $1444: $a7
    jr z, jr_000_1448                             ; $1445: $28 $01

    dec a                                         ; $1447: $3d

jr_000_1448:
    ld [hl+], a                                   ; $1448: $22
    ld a, [$d124]                                 ; $1449: $fa $24 $d1
    and a                                         ; $144c: $a7

Jump_000_144d:
    ld a, $03                                     ; $144d: $3e $03
    jr z, jr_000_1456                             ; $144f: $28 $05

    xor a                                         ; $1451: $af
    ld [$d124], a                                 ; $1452: $ea $24 $d1
    inc a                                         ; $1455: $3c

jr_000_1456:
    ld [hl+], a                                   ; $1456: $22
    pop af                                        ; $1457: $f1
    ld [hl], a                                    ; $1458: $77
    ret                                           ; $1459: $c9


Call_000_145a:
Jump_000_145a:
jr_000_145a:
    ld a, $01                                     ; $145a: $3e $01
    ld [$cc4a], a                                 ; $145c: $ea $4a $cc
    ld a, $40                                     ; $145f: $3e $40
    ld [$d0a0], a                                 ; $1461: $ea $a0 $d0
    call Call_000_3adf                            ; $1464: $cd $df $3a
    call Call_000_3c09                            ; $1467: $cd $09 $3c
    ld b, a                                       ; $146a: $47
    xor a                                         ; $146b: $af
    ld [$d0a0], a                                 ; $146c: $ea $a0 $d0
    ld a, [$cc26]                                 ; $146f: $fa $26 $cc
    ld [$cc2b], a                                 ; $1472: $ea $2b $cc
    ld hl, $d735                                  ; $1475: $21 $35 $d7
    res 6, [hl]                                   ; $1478: $cb $b6
    ld a, [$cc35]                                 ; $147a: $fa $35 $cc
    and a                                         ; $147d: $a7
    jp nz, Jump_000_14ac                          ; $147e: $c2 $ac $14

    pop af                                        ; $1481: $f1
    ldh [$d7], a                                  ; $1482: $e0 $d7
    bit 1, b                                      ; $1484: $cb $48
    jr nz, jr_000_14a7                            ; $1486: $20 $1f

    ld a, [$d168]                                 ; $1488: $fa $68 $d1
    and a                                         ; $148b: $a7

Call_000_148c:
Jump_000_148c:
    jr z, jr_000_14a7                             ; $148c: $28 $19

    ld a, [$cc26]                                 ; $148e: $fa $26 $cc

Call_000_1491:
    ld [$cf97], a                                 ; $1491: $ea $97 $cf
    ld hl, $d169                                  ; $1494: $21 $69 $d1

Jump_000_1497:
    ld b, $00                                     ; $1497: $06 $00
    ld c, a                                       ; $1499: $4f
    add hl, bc                                    ; $149a: $09
    ld a, [hl]                                    ; $149b: $7e
    ld [$cf96], a                                 ; $149c: $ea $96 $cf
    ld [$cfde], a                                 ; $149f: $ea $de $cf
    call Call_000_35ea                            ; $14a2: $cd $ea $35
    and a                                         ; $14a5: $a7
    ret                                           ; $14a6: $c9


jr_000_14a7:
    call Call_000_35ea                            ; $14a7: $cd $ea $35
    scf                                           ; $14aa: $37
    ret                                           ; $14ab: $c9


Jump_000_14ac:
    bit 1, b                                      ; $14ac: $cb $48
    jr z, jr_000_14c4                             ; $14ae: $28 $14

    ld b, $04                                     ; $14b0: $06 $04
    ld hl, $72fb                                  ; $14b2: $21 $fb $72
    call Call_000_35f3                            ; $14b5: $cd $f3 $35
    xor a                                         ; $14b8: $af
    ld [$cc35], a                                 ; $14b9: $ea $35 $cc
    ld [$d082], a                                 ; $14bc: $ea $82 $d0
    call Call_000_14d9                            ; $14bf: $cd $d9 $14

Call_000_14c2:
    jr jr_000_145a                                ; $14c2: $18 $96

jr_000_14c4:
    ld a, [$cc26]                                 ; $14c4: $fa $26 $cc
    ld [$cf97], a                                 ; $14c7: $ea $97 $cf
    ld b, $04                                     ; $14ca: $06 $04
    ld hl, $7622                                  ; $14cc: $21 $22 $76
    call Call_000_35f3                            ; $14cf: $cd $f3 $35
    jr jr_000_145a                                ; $14d2: $18 $86

Call_000_14d4:
Jump_000_14d4:
    ld hl, $6ce0                                  ; $14d4: $21 $e0 $6c
    jr jr_000_14dc                                ; $14d7: $18 $03

Call_000_14d9:
    ld hl, $6cf1                                  ; $14d9: $21 $f1 $6c

jr_000_14dc:
    ld b, $04                                     ; $14dc: $06 $04
    jp Jump_000_35f3                              ; $14de: $c3 $f3 $35


Call_000_14e1:
    push de                                       ; $14e1: $d5
    dec de                                        ; $14e2: $1b
    dec de                                        ; $14e3: $1b
    ld a, [de]                                    ; $14e4: $1a
    ld b, a                                       ; $14e5: $47
    dec de                                        ; $14e6: $1b
    ld a, [de]                                    ; $14e7: $1a
    or b                                          ; $14e8: $b0
    pop de                                        ; $14e9: $d1
    jr nz, jr_000_14f3                            ; $14ea: $20 $07

    ld a, $8a                                     ; $14ec: $3e $8a
    ld [hl+], a                                   ; $14ee: $22
    ld [hl], $8e                                  ; $14ef: $36 $8e
    and a                                         ; $14f1: $a7

Call_000_14f2:
    ret                                           ; $14f2: $c9


Call_000_14f3:
jr_000_14f3:
    ldh a, [$b8]                                  ; $14f3: $f0 $b8
    push af                                       ; $14f5: $f5
    ld a, $1d                                     ; $14f6: $3e $1d
    ldh [$b8], a                                  ; $14f8: $e0 $b8
    ld [$2000], a                                 ; $14fa: $ea $00 $20
    call $482b                                    ; $14fd: $cd $2b $48

Jump_000_1500:
    pop bc                                        ; $1500: $c1

Call_000_1501:
Jump_000_1501:
    ld a, b                                       ; $1501: $78

Jump_000_1502:
    ldh [$b8], a                                  ; $1502: $e0 $b8

Jump_000_1504:
    ld [$2000], a                                 ; $1504: $ea $00 $20

Call_000_1507:
Jump_000_1507:
    ret                                           ; $1507: $c9


Call_000_1508:
Jump_000_1508:
    ld a, $6e                                     ; $1508: $3e $6e

Call_000_150a:
Jump_000_150a:
    ld [hl+], a                                   ; $150a: $22

Call_000_150b:
    ld c, $02                                     ; $150b: $0e $02

Jump_000_150d:
    ld a, [$cfbe]                                 ; $150d: $fa $be $cf
    cp $64                                        ; $1510: $fe $64
    jr c, jr_000_1520                             ; $1512: $38 $0c

    dec hl                                        ; $1514: $2b
    inc c                                         ; $1515: $0c
    jr jr_000_1520                                ; $1516: $18 $08

    ld a, $6e                                     ; $1518: $3e $6e

Call_000_151a:
    ld [hl+], a                                   ; $151a: $22
    ld c, $03                                     ; $151b: $0e $03
    ld a, [$cfbe]                                 ; $151d: $fa $be $cf

Call_000_1520:
jr_000_1520:
    ld [$d123], a                                 ; $1520: $ea $23 $d1

Call_000_1523:
    ld de, $d123                                  ; $1523: $11 $23 $d1

Call_000_1526:
    ld b, $41                                     ; $1526: $06 $41
    jp Jump_000_3c7c                              ; $1528: $c3 $7c $3c


    ld hl, $d0e1                                  ; $152b: $21 $e1 $d0
    ld c, a                                       ; $152e: $4f
    ld b, $00                                     ; $152f: $06 $00
    add hl, bc                                    ; $1531: $09
    ld a, [hl]                                    ; $1532: $7e
    ret                                           ; $1533: $c9


Call_000_1534:
    ldh a, [$b8]                                  ; $1534: $f0 $b8
    push af                                       ; $1536: $f5
    ld a, $0e                                     ; $1537: $3e $0e

Call_000_1539:
    ldh [$b8], a                                  ; $1539: $e0 $b8
    ld [$2000], a                                 ; $153b: $ea $00 $20
    push bc                                       ; $153e: $c5
    push de                                       ; $153f: $d5
    push hl                                       ; $1540: $e5
    ld a, [$d123]                                 ; $1541: $fa $23 $d1
    push af                                       ; $1544: $f5
    ld a, [$d0ba]                                 ; $1545: $fa $ba $d0
    ld [$d123], a                                 ; $1548: $ea $23 $d1
    ld de, $79e8                                  ; $154b: $11 $e8 $79

Jump_000_154e:
    ld b, $66                                     ; $154e: $06 $66
    cp $b6                                        ; $1550: $fe $b6
    jr z, jr_000_1585                             ; $1552: $28 $31

Call_000_1554:
    ld de, $66b5                                  ; $1554: $11 $b5 $66
    cp $b8                                        ; $1557: $fe $b8
    jr z, jr_000_1585                             ; $1559: $28 $2a

    ld de, $6536                                  ; $155b: $11 $36 $65
    ld b, $77                                     ; $155e: $06 $77
    cp $b7                                        ; $1560: $fe $b7
    jr z, jr_000_1585                             ; $1562: $28 $21

    cp $15                                        ; $1564: $fe $15
    jr z, jr_000_158f                             ; $1566: $28 $27

    ld a, $3a                                     ; $1568: $3e $3a
    call Call_000_3e8a                            ; $156a: $cd $8a $3e
    ld a, [$d123]                                 ; $156d: $fa $23 $d1
    dec a                                         ; $1570: $3d
    ld bc, $001c                                  ; $1571: $01 $1c $00
    ld hl, $43de                                  ; $1574: $21 $de $43
    call Call_000_3aa4                            ; $1577: $cd $a4 $3a
    ld de, $d0bd                                  ; $157a: $11 $bd $d0
    ld bc, $001c                                  ; $157d: $01 $1c $00
    call Call_000_00b5                            ; $1580: $cd $b5 $00

Jump_000_1583:
    jr jr_000_159d                                ; $1583: $18 $18

jr_000_1585:
    ld hl, $d0c7                                  ; $1585: $21 $c7 $d0
    ld [hl], b                                    ; $1588: $70
    inc hl                                        ; $1589: $23
    ld [hl], e                                    ; $158a: $73
    inc hl                                        ; $158b: $23
    ld [hl], d                                    ; $158c: $72
    jr jr_000_159d                                ; $158d: $18 $0e

jr_000_158f:
    ld hl, $425b                                  ; $158f: $21 $5b $42
    ld de, $d0bd                                  ; $1592: $11 $bd $d0
    ld bc, $001c                                  ; $1595: $01 $1c $00
    ld a, $01                                     ; $1598: $3e $01
    call Call_000_009d                            ; $159a: $cd $9d $00

jr_000_159d:
    ld a, [$d0ba]                                 ; $159d: $fa $ba $d0

Call_000_15a0:
    ld [$d0bd], a                                 ; $15a0: $ea $bd $d0
    pop af                                        ; $15a3: $f1

Call_000_15a4:
    ld [$d123], a                                 ; $15a4: $ea $23 $d1

Call_000_15a7:
    pop hl                                        ; $15a7: $e1
    pop de                                        ; $15a8: $d1
    pop bc                                        ; $15a9: $c1

Jump_000_15aa:
    pop af                                        ; $15aa: $f1
    ldh [$b8], a                                  ; $15ab: $e0 $b8
    ld [$2000], a                                 ; $15ad: $ea $00 $20
    ret                                           ; $15b0: $c9


Call_000_15b1:
    ld a, [$cf97]                                 ; $15b1: $fa $97 $cf
    ld hl, $d2ba                                  ; $15b4: $21 $ba $d2

Call_000_15b7:
    push hl                                       ; $15b7: $e5
    push bc                                       ; $15b8: $c5
    call Call_000_3a9a                            ; $15b9: $cd $9a $3a
    ld de, $cd6d                                  ; $15bc: $11 $6d $cd
    push de                                       ; $15bf: $d5
    ld bc, $000b                                  ; $15c0: $01 $0b $00
    call Call_000_00b5                            ; $15c3: $cd $b5 $00
    pop de                                        ; $15c6: $d1

Jump_000_15c7:
    pop bc                                        ; $15c7: $c1
    pop hl                                        ; $15c8: $e1
    ret                                           ; $15c9: $c9


Call_000_15ca:
Jump_000_15ca:
    ld b, c                                       ; $15ca: $41
    res 7, c                                      ; $15cb: $cb $b9
    res 6, c                                      ; $15cd: $cb $b1
    res 5, c                                      ; $15cf: $cb $a9
    bit 5, b                                      ; $15d1: $cb $68

Jump_000_15d3:
    jr z, jr_000_15dc                             ; $15d3: $28 $07

    bit 7, b                                      ; $15d5: $cb $78
    jr nz, jr_000_15dc                            ; $15d7: $20 $03

    ld [hl], $f0                                  ; $15d9: $36 $f0
    inc hl                                        ; $15db: $23

jr_000_15dc:
    ld a, [de]                                    ; $15dc: $1a
    swap a                                        ; $15dd: $cb $37
    call Call_000_1601                            ; $15df: $cd $01 $16
    ld a, [de]                                    ; $15e2: $1a
    call Call_000_1601                            ; $15e3: $cd $01 $16
    inc de                                        ; $15e6: $13
    dec c                                         ; $15e7: $0d
    jr nz, jr_000_15dc                            ; $15e8: $20 $f2

    bit 7, b                                      ; $15ea: $cb $78
    jr z, jr_000_1600                             ; $15ec: $28 $12

    bit 6, b                                      ; $15ee: $cb $70
    jr nz, jr_000_15f3                            ; $15f0: $20 $01

    dec hl                                        ; $15f2: $2b

jr_000_15f3:
    bit 5, b                                      ; $15f3: $cb $68
    jr z, jr_000_15fa                             ; $15f5: $28 $03

    ld [hl], $f0                                  ; $15f7: $36 $f0

Call_000_15f9:
    inc hl                                        ; $15f9: $23

jr_000_15fa:
    ld [hl], $f6                                  ; $15fa: $36 $f6
    call Call_000_38f0                            ; $15fc: $cd $f0 $38
    inc hl                                        ; $15ff: $23

jr_000_1600:
    ret                                           ; $1600: $c9


Call_000_1601:
    and $0f                                       ; $1601: $e6 $0f
    and a                                         ; $1603: $a7
    jr z, jr_000_161b                             ; $1604: $28 $15

    bit 7, b                                      ; $1606: $cb $78
    jr z, jr_000_1615                             ; $1608: $28 $0b

    bit 5, b                                      ; $160a: $cb $68
    jr z, jr_000_1613                             ; $160c: $28 $05

    ld [hl], $f0                                  ; $160e: $36 $f0
    inc hl                                        ; $1610: $23
    res 5, b                                      ; $1611: $cb $a8

jr_000_1613:
    res 7, b                                      ; $1613: $cb $b8

jr_000_1615:
    add $f6                                       ; $1615: $c6 $f6
    ld [hl+], a                                   ; $1617: $22
    jp Jump_000_38f0                              ; $1618: $c3 $f0 $38


jr_000_161b:
    bit 7, b                                      ; $161b: $cb $78
    jr z, jr_000_1615                             ; $161d: $28 $f6

    bit 6, b                                      ; $161f: $cb $70
    ret nz                                        ; $1621: $c0

Jump_000_1622:
    inc hl                                        ; $1622: $23
    ret                                           ; $1623: $c9


Call_000_1624:
    ld bc, $d0bd                                  ; $1624: $01 $bd $d0
    add hl, bc                                    ; $1627: $09
    ld a, [hl+]                                   ; $1628: $2a
    ld [$d0b0], a                                 ; $1629: $ea $b0 $d0

Jump_000_162c:
    ld a, [hl]                                    ; $162c: $7e
    ld [$d0b1], a                                 ; $162d: $ea $b1 $d0
    ld a, [$cf96]                                 ; $1630: $fa $96 $cf
    ld b, a                                       ; $1633: $47
    cp $15                                        ; $1634: $fe $15
    ld a, $01                                     ; $1636: $3e $01
    jr z, jr_000_165f                             ; $1638: $28 $25

    ld a, b                                       ; $163a: $78
    cp $b6                                        ; $163b: $fe $b6
    ld a, $0b                                     ; $163d: $3e $0b
    jr z, jr_000_165f                             ; $163f: $28 $1e

    ld a, b                                       ; $1641: $78
    cp $1f                                        ; $1642: $fe $1f
    ld a, $09                                     ; $1644: $3e $09
    jr c, jr_000_165f                             ; $1646: $38 $17

    ld a, b                                       ; $1648: $78
    cp $4a                                        ; $1649: $fe $4a
    ld a, $0a                                     ; $164b: $3e $0a
    jr c, jr_000_165f                             ; $164d: $38 $10

    ld a, b                                       ; $164f: $78
    cp $74                                        ; $1650: $fe $74
    ld a, $0b                                     ; $1652: $3e $0b
    jr c, jr_000_165f                             ; $1654: $38 $09

    ld a, b                                       ; $1656: $78
    cp $99                                        ; $1657: $fe $99
    ld a, $0c                                     ; $1659: $3e $0c
    jr c, jr_000_165f                             ; $165b: $38 $02

    ld a, $0d                                     ; $165d: $3e $0d

jr_000_165f:
    jp Jump_000_24f9                              ; $165f: $c3 $f9 $24


Call_000_1662:
    push de                                       ; $1662: $d5
    ld hl, $000b                                  ; $1663: $21 $0b $00
    call Call_000_1624                            ; $1666: $cd $24 $16
    ld hl, $d0c7                                  ; $1669: $21 $c7 $d0
    ld a, [hl+]                                   ; $166c: $2a
    ld c, a                                       ; $166d: $4f
    pop de                                        ; $166e: $d1

Jump_000_166f:
    push de                                       ; $166f: $d5
    and $0f                                       ; $1670: $e6 $0f
    ldh [$8b], a                                  ; $1672: $e0 $8b
    ld b, a                                       ; $1674: $47
    ld a, $07                                     ; $1675: $3e $07
    sub b                                         ; $1677: $90
    inc a                                         ; $1678: $3c
    srl a                                         ; $1679: $cb $3f
    ld b, a                                       ; $167b: $47
    add a                                         ; $167c: $87
    add a                                         ; $167d: $87
    add a                                         ; $167e: $87
    sub b                                         ; $167f: $90
    ldh [$8d], a                                  ; $1680: $e0 $8d
    ld a, c                                       ; $1682: $79
    swap a                                        ; $1683: $cb $37
    and $0f                                       ; $1685: $e6 $0f
    ld b, a                                       ; $1687: $47
    add a                                         ; $1688: $87
    add a                                         ; $1689: $87
    add a                                         ; $168a: $87
    ldh [$8c], a                                  ; $168b: $e0 $8c
    ld a, $07                                     ; $168d: $3e $07
    sub b                                         ; $168f: $90
    ld b, a                                       ; $1690: $47
    ldh a, [$8d]                                  ; $1691: $f0 $8d
    add b                                         ; $1693: $80
    add a                                         ; $1694: $87
    add a                                         ; $1695: $87
    add a                                         ; $1696: $87
    ldh [$8d], a                                  ; $1697: $e0 $8d
    xor a                                         ; $1699: $af
    ld [$4000], a                                 ; $169a: $ea $00 $40
    ld hl, $a000                                  ; $169d: $21 $00 $a0
    call Call_000_16dc                            ; $16a0: $cd $dc $16
    ld de, $a188                                  ; $16a3: $11 $88 $a1
    ld hl, $a000                                  ; $16a6: $21 $00 $a0
    call Call_000_16bf                            ; $16a9: $cd $bf $16
    ld hl, $a188                                  ; $16ac: $21 $88 $a1
    call Call_000_16dc                            ; $16af: $cd $dc $16
    ld de, $a310                                  ; $16b2: $11 $10 $a3
    ld hl, $a188                                  ; $16b5: $21 $88 $a1
    call Call_000_16bf                            ; $16b8: $cd $bf $16
    pop de                                        ; $16bb: $d1
    jp Jump_000_16e7                              ; $16bc: $c3 $e7 $16


Call_000_16bf:
    ldh a, [$8d]                                  ; $16bf: $f0 $8d
    ld b, $00                                     ; $16c1: $06 $00
    ld c, a                                       ; $16c3: $4f
    add hl, bc                                    ; $16c4: $09
    ldh a, [$8b]                                  ; $16c5: $f0 $8b

jr_000_16c7:
    push af                                       ; $16c7: $f5
    push hl                                       ; $16c8: $e5
    ldh a, [$8c]                                  ; $16c9: $f0 $8c
    ld c, a                                       ; $16cb: $4f

jr_000_16cc:
    ld a, [de]                                    ; $16cc: $1a
    inc de                                        ; $16cd: $13
    ld [hl+], a                                   ; $16ce: $22
    dec c                                         ; $16cf: $0d

Call_000_16d0:
    jr nz, jr_000_16cc                            ; $16d0: $20 $fa

    pop hl                                        ; $16d2: $e1
    ld bc, $0038                                  ; $16d3: $01 $38 $00
    add hl, bc                                    ; $16d6: $09
    pop af                                        ; $16d7: $f1
    dec a                                         ; $16d8: $3d
    jr nz, jr_000_16c7                            ; $16d9: $20 $ec

    ret                                           ; $16db: $c9


Call_000_16dc:
    ld bc, $0188                                  ; $16dc: $01 $88 $01

jr_000_16df:
    xor a                                         ; $16df: $af
    ld [hl+], a                                   ; $16e0: $22
    dec bc                                        ; $16e1: $0b
    ld a, b                                       ; $16e2: $78
    or c                                          ; $16e3: $b1
    jr nz, jr_000_16df                            ; $16e4: $20 $f9

    ret                                           ; $16e6: $c9


Call_000_16e7:
Jump_000_16e7:
    xor a                                         ; $16e7: $af
    ld [$4000], a                                 ; $16e8: $ea $00 $40
    push de                                       ; $16eb: $d5
    ld hl, $a497                                  ; $16ec: $21 $97 $a4
    ld de, $a30f                                  ; $16ef: $11 $0f $a3
    ld bc, $a187                                  ; $16f2: $01 $87 $a1
    ld a, $c4                                     ; $16f5: $3e $c4
    ldh [$8b], a                                  ; $16f7: $e0 $8b

jr_000_16f9:
    ld a, [de]                                    ; $16f9: $1a
    dec de                                        ; $16fa: $1b
    ld [hl-], a                                   ; $16fb: $32
    ld a, [bc]                                    ; $16fc: $0a
    dec bc                                        ; $16fd: $0b
    ld [hl-], a                                   ; $16fe: $32
    ld a, [de]                                    ; $16ff: $1a

Jump_000_1700:
    dec de                                        ; $1700: $1b

Jump_000_1701:
    ld [hl-], a                                   ; $1701: $32
    ld a, [bc]                                    ; $1702: $0a
    dec bc                                        ; $1703: $0b

Call_000_1704:
    ld [hl-], a                                   ; $1704: $32
    ldh a, [$8b]                                  ; $1705: $f0 $8b
    dec a                                         ; $1707: $3d
    ldh [$8b], a                                  ; $1708: $e0 $8b
    jr nz, jr_000_16f9                            ; $170a: $20 $ed

    ld a, [$d0af]                                 ; $170c: $fa $af $d0
    and a                                         ; $170f: $a7
    jr z, jr_000_1720                             ; $1710: $28 $0e

    ld bc, $0310                                  ; $1712: $01 $10 $03
    ld hl, $a188                                  ; $1715: $21 $88 $a1

jr_000_1718:
    swap [hl]                                     ; $1718: $cb $36
    inc hl                                        ; $171a: $23
    dec bc                                        ; $171b: $0b
    ld a, b                                       ; $171c: $78
    or c                                          ; $171d: $b1
    jr nz, jr_000_1718                            ; $171e: $20 $f8

jr_000_1720:
    pop hl                                        ; $1720: $e1
    ld de, $a188                                  ; $1721: $11 $88 $a1
    ld c, $31                                     ; $1724: $0e $31
    ldh a, [$b8]                                  ; $1726: $f0 $b8
    ld b, a                                       ; $1728: $47
    jp Jump_000_1845                              ; $1729: $c3 $45 $18


    dec bc                                        ; $172c: $0b
    inc c                                         ; $172d: $0c
    inc de                                        ; $172e: $13
    dec d                                         ; $172f: $15
    jr @+$01                                      ; $1730: $18 $ff

    nop                                           ; $1732: $00
    db $10                                        ; $1733: $10
    dec de                                        ; $1734: $1b
    jr nz, @+$23                                  ; $1735: $20 $21

    inc hl                                        ; $1737: $23
    inc l                                         ; $1738: $2c
    dec l                                         ; $1739: $2d
    ld l, $30                                     ; $173a: $2e $30
    ld sp, $3933                                  ; $173c: $31 $33 $39
    inc a                                         ; $173f: $3c
    ld a, $52                                     ; $1740: $3e $52
    ld d, h                                       ; $1742: $54
    ld e, b                                       ; $1743: $58
    ld e, e                                       ; $1744: $5b
    rst $38                                       ; $1745: $ff
    ld bc, $0302                                  ; $1746: $01 $02 $03
    ld de, $1312                                  ; $1749: $11 $12 $13
    inc d                                         ; $174c: $14
    inc e                                         ; $174d: $1c
    ld a, [de]                                    ; $174e: $1a
    rst $38                                       ; $174f: $ff
    ld de, $1c1a                                  ; $1750: $11 $1a $1c
    inc a                                         ; $1753: $3c
    ld e, [hl]                                    ; $1754: $5e
    rst $38                                       ; $1755: $ff
    ld de, $1916                                  ; $1756: $11 $16 $19
    dec hl                                        ; $1759: $2b
    inc a                                         ; $175a: $3c
    dec a                                         ; $175b: $3d

Call_000_175c:
    ccf                                           ; $175c: $3f

Call_000_175d:
    ld c, d                                       ; $175d: $4a
    ld c, h                                       ; $175e: $4c
    ld c, l                                       ; $175f: $4d
    inc bc                                        ; $1760: $03
    rst $38                                       ; $1761: $ff
    ld e, $20                                     ; $1762: $1e $20
    ld l, $30                                     ; $1764: $2e $30
    inc [hl]                                      ; $1766: $34

Jump_000_1767:
    scf                                           ; $1767: $37
    add hl, sp                                    ; $1768: $39
    ld a, [hl-]                                   ; $1769: $3a
    ld b, b                                       ; $176a: $40
    ld d, c                                       ; $176b: $51
    ld d, d                                       ; $176c: $52
    ld e, d                                       ; $176d: $5a
    ld e, h                                       ; $176e: $5c
    ld e, [hl]                                    ; $176f: $5e
    ld e, a                                       ; $1770: $5f
    rst $38                                       ; $1771: $ff
    ld bc, $1412                                  ; $1772: $01 $12 $14
    jr z, jr_000_17a9                             ; $1775: $28 $32

    scf                                           ; $1777: $37
    ld b, h                                       ; $1778: $44
    ld d, h                                       ; $1779: $54
    ld e, h                                       ; $177a: $5c
    rst $38                                       ; $177b: $ff
    ld bc, $1412                                  ; $177c: $01 $12 $14
    ld a, [de]                                    ; $177f: $1a
    inc e                                         ; $1780: $1c
    scf                                           ; $1781: $37
    jr c, @+$3d                                   ; $1782: $38 $3b

    inc a                                         ; $1784: $3c
    ld e, [hl]                                    ; $1785: $5e
    rst $38                                       ; $1786: $ff
    inc b                                         ; $1787: $04
    dec c                                         ; $1788: $0d
    rla                                           ; $1789: $17
    dec e                                         ; $178a: $1d
    ld e, $23                                     ; $178b: $1e $23
    inc [hl]                                      ; $178d: $34
    scf                                           ; $178e: $37
    add hl, sp                                    ; $178f: $39
    ld c, d                                       ; $1790: $4a
    rst $38                                       ; $1791: $ff
    ld a, [bc]                                    ; $1792: $0a
    ld a, [de]                                    ; $1793: $1a
    ld [hl-], a                                   ; $1794: $32
    dec sp                                        ; $1795: $3b
    rst $38                                       ; $1796: $ff
    ld bc, $1310                                  ; $1797: $01 $10 $13
    dec de                                        ; $179a: $1b
    ld [hl+], a                                   ; $179b: $22
    ld b, d                                       ; $179c: $42
    ld d, d                                       ; $179d: $52
    rst $38                                       ; $179e: $ff
    inc b                                         ; $179f: $04

Call_000_17a0:
    rrca                                          ; $17a0: $0f
    dec d                                         ; $17a1: $15
    rra                                           ; $17a2: $1f
    dec sp                                        ; $17a3: $3b
    ld b, l                                       ; $17a4: $45
    ld b, a                                       ; $17a5: $47
    ld d, l                                       ; $17a6: $55

Call_000_17a7:
    ld d, [hl]                                    ; $17a7: $56
    rst $38                                       ; $17a8: $ff

jr_000_17a9:
    dec b                                         ; $17a9: $05
    dec d                                         ; $17aa: $15
    jr jr_000_17c7                                ; $17ab: $18 $1a

    jr nz, jr_000_17d0                            ; $17ad: $20 $21

    ld [hl+], a                                   ; $17af: $22
    ld a, [hl+]                                   ; $17b0: $2a
    dec l                                         ; $17b1: $2d
    jr nc, @+$01                                  ; $17b2: $30 $ff

    rst $38                                       ; $17b4: $ff
    inc d                                         ; $17b5: $14
    rla                                           ; $17b6: $17

Call_000_17b7:
    ld a, [de]                                    ; $17b7: $1a
    inc e                                         ; $17b8: $1c
    jr nz, jr_000_17f3                            ; $17b9: $20 $38

    ld b, l                                       ; $17bb: $45
    rst $38                                       ; $17bc: $ff
    ld bc, $1105                                  ; $17bd: $01 $05 $11
    ld [de], a                                    ; $17c0: $12
    inc d                                         ; $17c1: $14
    ld a, [de]                                    ; $17c2: $1a
    inc e                                         ; $17c3: $1c
    inc l                                         ; $17c4: $2c
    ld d, e                                       ; $17c5: $53
    rst $38                                       ; $17c6: $ff

Call_000_17c7:
jr_000_17c7:
    inc c                                         ; $17c7: $0c
    ld h, $16                                     ; $17c8: $26 $16
    ld e, $34                                     ; $17ca: $1e $34
    scf                                           ; $17cc: $37
    rst $38                                       ; $17cd: $ff
    rrca                                          ; $17ce: $0f
    ld a, [de]                                    ; $17cf: $1a

jr_000_17d0:
    rra                                           ; $17d0: $1f
    ld h, $28                                     ; $17d1: $26 $28
    add hl, hl                                    ; $17d3: $29
    inc l                                         ; $17d4: $2c
    dec l                                         ; $17d5: $2d
    ld l, $2f                                     ; $17d6: $2e $2f
    ld b, c                                       ; $17d8: $41
    rst $38                                       ; $17d9: $ff

Call_000_17da:
    ld bc, $1110                                  ; $17da: $01 $10 $11
    inc de                                        ; $17dd: $13
    dec de                                        ; $17de: $1b
    jr nz, @+$23                                  ; $17df: $20 $21

    ld [hl+], a                                   ; $17e1: $22
    jr nc, @+$33                                  ; $17e2: $30 $31

    ld [hl-], a                                   ; $17e4: $32
    ld b, d                                       ; $17e5: $42
    ld b, e                                       ; $17e6: $43
    ld c, b                                       ; $17e7: $48
    ld d, d                                       ; $17e8: $52
    ld d, l                                       ; $17e9: $55
    ld e, b                                       ; $17ea: $58
    ld e, [hl]                                    ; $17eb: $5e
    rst $38                                       ; $17ec: $ff
    dec de                                        ; $17ed: $1b
    inc hl                                        ; $17ee: $23
    inc l                                         ; $17ef: $2c
    dec l                                         ; $17f0: $2d

Jump_000_17f1:
    dec sp                                        ; $17f1: $3b
    ld b, l                                       ; $17f2: $45

jr_000_17f3:
    rst $38                                       ; $17f3: $ff

Call_000_17f4:
Jump_000_17f4:
    ldh [$8b], a                                  ; $17f4: $e0 $8b
    ldh a, [$b8]                                  ; $17f6: $f0 $b8
    push af                                       ; $17f8: $f5
    ldh a, [$8b]                                  ; $17f9: $f0 $8b
    ldh [$b8], a                                  ; $17fb: $e0 $b8
    ld [$2000], a                                 ; $17fd: $ea $00 $20
    call Call_000_00b5                            ; $1800: $cd $b5 $00
    pop af                                        ; $1803: $f1
    ldh [$b8], a                                  ; $1804: $e0 $b8
    ld [$2000], a                                 ; $1806: $ea $00 $20
    ret                                           ; $1809: $c9


    ldh [$8b], a                                  ; $180a: $e0 $8b
    ldh a, [$b8]                                  ; $180c: $f0 $b8
    push af                                       ; $180e: $f5
    ldh a, [$8b]                                  ; $180f: $f0 $8b
    ldh [$b8], a                                  ; $1811: $e0 $b8
    ld [$2000], a                                 ; $1813: $ea $00 $20
    push hl                                       ; $1816: $e5
    push de                                       ; $1817: $d5
    push de                                       ; $1818: $d5
    ld d, h                                       ; $1819: $54
    ld e, l                                       ; $181a: $5d
    pop hl                                        ; $181b: $e1
    call Call_000_00b5                            ; $181c: $cd $b5 $00
    pop de                                        ; $181f: $d1
    pop hl                                        ; $1820: $e1

Call_000_1821:
    pop af                                        ; $1821: $f1
    ldh [$b8], a                                  ; $1822: $e0 $b8
    ld [$2000], a                                 ; $1824: $ea $00 $20
    ret                                           ; $1827: $c9


Call_000_1828:
Jump_000_1828:
    ldh [$8b], a                                  ; $1828: $e0 $8b
    ldh a, [$b8]                                  ; $182a: $f0 $b8
    push af                                       ; $182c: $f5
    ldh a, [$8b]                                  ; $182d: $f0 $8b
    ldh [$b8], a                                  ; $182f: $e0 $b8
    ld [$2000], a                                 ; $1831: $ea $00 $20

jr_000_1834:
    ld a, [hl+]                                   ; $1834: $2a
    ld [de], a                                    ; $1835: $12
    inc de                                        ; $1836: $13
    ld [de], a                                    ; $1837: $12
    inc de                                        ; $1838: $13
    dec bc                                        ; $1839: $0b
    ld a, c                                       ; $183a: $79
    or b                                          ; $183b: $b0
    jr nz, jr_000_1834                            ; $183c: $20 $f6

    pop af                                        ; $183e: $f1
    ldh [$b8], a                                  ; $183f: $e0 $b8
    ld [$2000], a                                 ; $1841: $ea $00 $20
    ret                                           ; $1844: $c9


Call_000_1845:
Jump_000_1845:
    ldh a, [$ba]                                  ; $1845: $f0 $ba
    push af                                       ; $1847: $f5
    xor a                                         ; $1848: $af
    ldh [$ba], a                                  ; $1849: $e0 $ba

Jump_000_184b:
    ldh a, [$b8]                                  ; $184b: $f0 $b8
    ldh [$8b], a                                  ; $184d: $e0 $8b
    ld a, b                                       ; $184f: $78
    ldh [$b8], a                                  ; $1850: $e0 $b8
    ld [$2000], a                                 ; $1852: $ea $00 $20
    ld a, e                                       ; $1855: $7b
    ldh [$c7], a                                  ; $1856: $e0 $c7
    ld a, d                                       ; $1858: $7a
    ldh [$c8], a                                  ; $1859: $e0 $c8
    ld a, l                                       ; $185b: $7d
    ldh [$c9], a                                  ; $185c: $e0 $c9
    ld a, h                                       ; $185e: $7c
    ldh [$ca], a                                  ; $185f: $e0 $ca

jr_000_1861:
    ld a, c                                       ; $1861: $79
    cp $08                                        ; $1862: $fe $08
    jr nc, jr_000_1876                            ; $1864: $30 $10

    ldh [$c6], a                                  ; $1866: $e0 $c6
    call Call_000_20ab                            ; $1868: $cd $ab $20
    ldh a, [$8b]                                  ; $186b: $f0 $8b
    ldh [$b8], a                                  ; $186d: $e0 $b8
    ld [$2000], a                                 ; $186f: $ea $00 $20
    pop af                                        ; $1872: $f1
    ldh [$ba], a                                  ; $1873: $e0 $ba
    ret                                           ; $1875: $c9


jr_000_1876:
    ld a, $08                                     ; $1876: $3e $08
    ldh [$c6], a                                  ; $1878: $e0 $c6
    call Call_000_20ab                            ; $187a: $cd $ab $20
    ld a, c                                       ; $187d: $79
    sub $08                                       ; $187e: $d6 $08
    ld c, a                                       ; $1880: $4f
    jr jr_000_1861                                ; $1881: $18 $de

Call_000_1883:
Jump_000_1883:
    ldh a, [$ba]                                  ; $1883: $f0 $ba
    push af                                       ; $1885: $f5

Jump_000_1886:
    xor a                                         ; $1886: $af
    ldh [$ba], a                                  ; $1887: $e0 $ba
    ldh a, [$b8]                                  ; $1889: $f0 $b8
    ldh [$8b], a                                  ; $188b: $e0 $8b

Jump_000_188d:
    ld a, b                                       ; $188d: $78
    ldh [$b8], a                                  ; $188e: $e0 $b8
    ld [$2000], a                                 ; $1890: $ea $00 $20
    ld a, e                                       ; $1893: $7b
    ldh [$cc], a                                  ; $1894: $e0 $cc
    ld a, d                                       ; $1896: $7a
    ldh [$cd], a                                  ; $1897: $e0 $cd
    ld a, l                                       ; $1899: $7d
    ldh [$ce], a                                  ; $189a: $e0 $ce
    ld a, h                                       ; $189c: $7c
    ldh [$cf], a                                  ; $189d: $e0 $cf

jr_000_189f:
    ld a, c                                       ; $189f: $79
    cp $08                                        ; $18a0: $fe $08
    jr nc, jr_000_18b4                            ; $18a2: $30 $10

    ldh [$cb], a                                  ; $18a4: $e0 $cb
    call Call_000_20ab                            ; $18a6: $cd $ab $20
    ldh a, [$8b]                                  ; $18a9: $f0 $8b
    ldh [$b8], a                                  ; $18ab: $e0 $b8
    ld [$2000], a                                 ; $18ad: $ea $00 $20
    pop af                                        ; $18b0: $f1
    ldh [$ba], a                                  ; $18b1: $e0 $ba
    ret                                           ; $18b3: $c9


jr_000_18b4:
    ld a, $08                                     ; $18b4: $3e $08
    ldh [$cb], a                                  ; $18b6: $e0 $cb
    call Call_000_20ab                            ; $18b8: $cd $ab $20
    ld a, c                                       ; $18bb: $79
    sub $08                                       ; $18bc: $d6 $08
    ld c, a                                       ; $18be: $4f
    jr jr_000_189f                                ; $18bf: $18 $de

Call_000_18c1:
Jump_000_18c1:
    ld a, $7f                                     ; $18c1: $3e $7f
    ld de, $0014                                  ; $18c3: $11 $14 $00

jr_000_18c6:
    push hl                                       ; $18c6: $e5
    push bc                                       ; $18c7: $c5

jr_000_18c8:
    ld [hl+], a                                   ; $18c8: $22
    dec c                                         ; $18c9: $0d
    jr nz, jr_000_18c8                            ; $18ca: $20 $fc

    pop bc                                        ; $18cc: $c1
    pop hl                                        ; $18cd: $e1
    add hl, de                                    ; $18ce: $19
    dec b                                         ; $18cf: $05
    jr nz, jr_000_18c6                            ; $18d0: $20 $f4

    ret                                           ; $18d2: $c9


Call_000_18d3:
    ld c, $06                                     ; $18d3: $0e $06
    ld hl, $0000                                  ; $18d5: $21 $00 $00
    ld de, $c3a0                                  ; $18d8: $11 $a0 $c3
    call Call_000_18f9                            ; $18db: $cd $f9 $18
    call Call_000_20ab                            ; $18de: $cd $ab $20
    ld hl, $0600                                  ; $18e1: $21 $00 $06
    ld de, $c418                                  ; $18e4: $11 $18 $c4
    call Call_000_18f9                            ; $18e7: $cd $f9 $18
    call Call_000_20ab                            ; $18ea: $cd $ab $20
    ld hl, $0c00                                  ; $18ed: $21 $00 $0c
    ld de, $c490                                  ; $18f0: $11 $90 $c4
    call Call_000_18f9                            ; $18f3: $cd $f9 $18
    jp Jump_000_20ab                              ; $18f6: $c3 $ab $20


Call_000_18f9:
    ld a, d                                       ; $18f9: $7a
    ldh [$c2], a                                  ; $18fa: $e0 $c2

Call_000_18fc:
    call Call_000_1cd9                            ; $18fc: $cd $d9 $1c
    ld a, l                                       ; $18ff: $7d
    ldh [$c3], a                                  ; $1900: $e0 $c3
    ld a, h                                       ; $1902: $7c
    ldh [$c4], a                                  ; $1903: $e0 $c4
    ld a, c                                       ; $1905: $79
    ldh [$c5], a                                  ; $1906: $e0 $c5
    ld a, e                                       ; $1908: $7b
    ldh [$c1], a                                  ; $1909: $e0 $c1
    ret                                           ; $190b: $c9


Call_000_190c:
Jump_000_190c:
    ld bc, $0168                                  ; $190c: $01 $68 $01
    inc b                                         ; $190f: $04
    ld hl, $c3a0                                  ; $1910: $21 $a0 $c3
    ld a, $7f                                     ; $1913: $3e $7f

jr_000_1915:
    ld [hl+], a                                   ; $1915: $22
    dec c                                         ; $1916: $0d
    jr nz, jr_000_1915                            ; $1917: $20 $fc

Jump_000_1919:
    dec b                                         ; $1919: $05
    jr nz, jr_000_1915                            ; $191a: $20 $f9

    jp Jump_000_3df4                              ; $191c: $c3 $f4 $3d


Call_000_191f:
    push hl                                       ; $191f: $e5
    ld a, $79                                     ; $1920: $3e $79
    ld [hl+], a                                   ; $1922: $22
    inc a                                         ; $1923: $3c
    call Call_000_194c                            ; $1924: $cd $4c $19
    inc a                                         ; $1927: $3c
    ld [hl], a                                    ; $1928: $77
    pop hl                                        ; $1929: $e1
    ld de, $0014                                  ; $192a: $11 $14 $00
    add hl, de                                    ; $192d: $19

jr_000_192e:
    push hl                                       ; $192e: $e5
    ld a, $7c                                     ; $192f: $3e $7c
    ld [hl+], a                                   ; $1931: $22
    ld a, $7f                                     ; $1932: $3e $7f
    call Call_000_194c                            ; $1934: $cd $4c $19
    ld [hl], $7c                                  ; $1937: $36 $7c
    pop hl                                        ; $1939: $e1
    ld de, $0014                                  ; $193a: $11 $14 $00
    add hl, de                                    ; $193d: $19
    dec b                                         ; $193e: $05
    jr nz, jr_000_192e                            ; $193f: $20 $ed

    ld a, $7d                                     ; $1941: $3e $7d
    ld [hl+], a                                   ; $1943: $22

Call_000_1944:
    ld a, $7a                                     ; $1944: $3e $7a
    call Call_000_194c                            ; $1946: $cd $4c $19
    ld [hl], $7e                                  ; $1949: $36 $7e
    ret                                           ; $194b: $c9


Call_000_194c:
    ld d, c                                       ; $194c: $51

jr_000_194d:
    ld [hl+], a                                   ; $194d: $22
    dec d                                         ; $194e: $15

Call_000_194f:
    jr nz, jr_000_194d                            ; $194f: $20 $fc

    ret                                           ; $1951: $c9


Call_000_1952:
Jump_000_1952:
    push hl                                       ; $1952: $e5

Jump_000_1953:
    ld a, [de]                                    ; $1953: $1a
    cp $50                                        ; $1954: $fe $50
    jr nz, jr_000_195c                            ; $1956: $20 $04

    ld b, h                                       ; $1958: $44
    ld c, l                                       ; $1959: $4d

Call_000_195a:
    pop hl                                        ; $195a: $e1
    ret                                           ; $195b: $c9


jr_000_195c:
    cp $4e                                        ; $195c: $fe $4e
    jr nz, jr_000_1972                            ; $195e: $20 $12

    ld bc, $0028                                  ; $1960: $01 $28 $00
    ldh a, [$f6]                                  ; $1963: $f0 $f6
    bit 2, a                                      ; $1965: $cb $57
    jr z, jr_000_196c                             ; $1967: $28 $03

    ld bc, $0014                                  ; $1969: $01 $14 $00

jr_000_196c:
    pop hl                                        ; $196c: $e1
    add hl, bc                                    ; $196d: $09
    push hl                                       ; $196e: $e5
    jp Jump_000_19e5                              ; $196f: $c3 $e5 $19


jr_000_1972:
    cp $4f                                        ; $1972: $fe $4f
    jr nz, jr_000_197e                            ; $1974: $20 $08

    pop hl                                        ; $1976: $e1
    ld hl, $c4e1                                  ; $1977: $21 $e1 $c4

Jump_000_197a:
    push hl                                       ; $197a: $e5
    jp Jump_000_19e5                              ; $197b: $c3 $e5 $19


jr_000_197e:
    and a                                         ; $197e: $a7
    jp z, Jump_000_19e9                           ; $197f: $ca $e9 $19

    cp $4c                                        ; $1982: $fe $4c
    jp z, Jump_000_1b06                           ; $1984: $ca $06 $1b

    cp $4b                                        ; $1987: $fe $4b
    jp z, Jump_000_1af4                           ; $1989: $ca $f4 $1a

    cp $51                                        ; $198c: $fe $51
    jp z, Jump_000_1ab0                           ; $198e: $ca $b0 $1a

    cp $49                                        ; $1991: $fe $49
    jp z, Jump_000_1ad1                           ; $1993: $ca $d1 $1a

    cp $52                                        ; $1996: $fe $52
    jp z, Jump_000_19f6                           ; $1998: $ca $f6 $19

    cp $53                                        ; $199b: $fe $53
    jp z, Jump_000_19fc                           ; $199d: $ca $fc $19

    cp $54                                        ; $19a0: $fe $54
    jp z, Jump_000_1a1a                           ; $19a2: $ca $1a $1a

    cp $5b                                        ; $19a5: $fe $5b
    jp z, Jump_000_1a0e                           ; $19a7: $ca $0e $1a

Jump_000_19aa:
    cp $5e                                        ; $19aa: $fe $5e
    jp z, Jump_000_1a14                           ; $19ac: $ca $14 $1a

    cp $5c                                        ; $19af: $fe $5c
    jp z, Jump_000_1a08                           ; $19b1: $ca $08 $1a

    cp $5d                                        ; $19b4: $fe $5d
    jp z, Jump_000_1a02                           ; $19b6: $ca $02 $1a

    cp $55                                        ; $19b9: $fe $55
    jp z, Jump_000_1a78                           ; $19bb: $ca $78 $1a

    cp $56                                        ; $19be: $fe $56
    jp z, Jump_000_1a20                           ; $19c0: $ca $20 $1a

    cp $57                                        ; $19c3: $fe $57
    jp z, Jump_000_1aa9                           ; $19c5: $ca $a9 $1a

    cp $58                                        ; $19c8: $fe $58
    jp z, Jump_000_1a91                           ; $19ca: $ca $91 $1a

    cp $4a                                        ; $19cd: $fe $4a
    jp z, Jump_000_1a26                           ; $19cf: $ca $26 $1a

    cp $5f                                        ; $19d2: $fe $5f
    jp z, Jump_000_1a8d                           ; $19d4: $ca $8d $1a

    cp $59                                        ; $19d7: $fe $59
    jp z, Jump_000_1a2c                           ; $19d9: $ca $2c $1a

    cp $5a                                        ; $19dc: $fe $5a
    jp z, Jump_000_1a32                           ; $19de: $ca $32 $1a

Jump_000_19e1:
    ld [hl+], a                                   ; $19e1: $22
    call Call_000_38f0                            ; $19e2: $cd $f0 $38

Jump_000_19e5:
    inc de                                        ; $19e5: $13
    jp Jump_000_1953                              ; $19e6: $c3 $53 $19


Jump_000_19e9:
    ld b, h                                       ; $19e9: $44
    ld c, l                                       ; $19ea: $4d
    pop hl                                        ; $19eb: $e1
    ld de, $19f1                                  ; $19ec: $11 $f1 $19
    dec de                                        ; $19ef: $1b
    ret                                           ; $19f0: $c9


    rla                                           ; $19f1: $17
    ld [hl], d                                    ; $19f2: $72
    ld l, c                                       ; $19f3: $69
    ld [hl+], a                                   ; $19f4: $22
    ld d, b                                       ; $19f5: $50

Jump_000_19f6:
    push de                                       ; $19f6: $d5
    ld de, $d15d                                  ; $19f7: $11 $5d $d1
    jr jr_000_1a48                                ; $19fa: $18 $4c

Jump_000_19fc:
    push de                                       ; $19fc: $d5
    ld de, $d34f                                  ; $19fd: $11 $4f $d3
    jr jr_000_1a48                                ; $1a00: $18 $46

Jump_000_1a02:
    push de                                       ; $1a02: $d5
    ld de, $1a65                                  ; $1a03: $11 $65 $1a
    jr jr_000_1a48                                ; $1a06: $18 $40

Jump_000_1a08:
    push de                                       ; $1a08: $d5

Jump_000_1a09:
    ld de, $1a62                                  ; $1a09: $11 $62 $1a
    jr jr_000_1a48                                ; $1a0c: $18 $3a

Jump_000_1a0e:
    push de                                       ; $1a0e: $d5

Jump_000_1a0f:
    ld de, $1a52                                  ; $1a0f: $11 $52 $1a
    jr jr_000_1a48                                ; $1a12: $18 $34

Jump_000_1a14:
    push de                                       ; $1a14: $d5
    ld de, $1a55                                  ; $1a15: $11 $55 $1a
    jr jr_000_1a48                                ; $1a18: $18 $2e

Jump_000_1a1a:
    push de                                       ; $1a1a: $d5
    ld de, $1a6b                                  ; $1a1b: $11 $6b $1a
    jr jr_000_1a48                                ; $1a1e: $18 $28

Jump_000_1a20:
    push de                                       ; $1a20: $d5
    ld de, $1a5c                                  ; $1a21: $11 $5c $1a
    jr jr_000_1a48                                ; $1a24: $18 $22

Jump_000_1a26:
    push de                                       ; $1a26: $d5
    ld de, $1a5f                                  ; $1a27: $11 $5f $1a
    jr jr_000_1a48                                ; $1a2a: $18 $1c

Jump_000_1a2c:
    ldh a, [$f3]                                  ; $1a2c: $f0 $f3
    xor $01                                       ; $1a2e: $ee $01
    jr jr_000_1a34                                ; $1a30: $18 $02

Jump_000_1a32:
    ldh a, [$f3]                                  ; $1a32: $f0 $f3

jr_000_1a34:
    push de                                       ; $1a34: $d5
    and a                                         ; $1a35: $a7
    jr nz, jr_000_1a3d                            ; $1a36: $20 $05

    ld de, $d00e                                  ; $1a38: $11 $0e $d0
    jr jr_000_1a48                                ; $1a3b: $18 $0b

jr_000_1a3d:
    ld de, $cfdf                                  ; $1a3d: $11 $df $cf
    call Call_000_1952                            ; $1a40: $cd $52 $19
    ld h, b                                       ; $1a43: $60
    ld l, c                                       ; $1a44: $69
    ld de, $1a70                                  ; $1a45: $11 $70 $1a

jr_000_1a48:
    call Call_000_1952                            ; $1a48: $cd $52 $19
    ld h, b                                       ; $1a4b: $60
    ld l, c                                       ; $1a4c: $69
    pop de                                        ; $1a4d: $d1
    inc de                                        ; $1a4e: $13

Jump_000_1a4f:
    jp Jump_000_1953                              ; $1a4f: $c3 $53 $19


    adc a                                         ; $1a52: $8f

Call_000_1a53:
    add d                                         ; $1a53: $82

Call_000_1a54:
    ld d, b                                       ; $1a54: $50
    sub c                                         ; $1a55: $91
    adc [hl]                                      ; $1a56: $8e
    add d                                         ; $1a57: $82
    adc d                                         ; $1a58: $8a
    add h                                         ; $1a59: $84
    sub e                                         ; $1a5a: $93
    ld d, b                                       ; $1a5b: $50
    ld [hl], l                                    ; $1a5c: $75
    ld [hl], l                                    ; $1a5d: $75
    ld d, b                                       ; $1a5e: $50
    pop hl                                        ; $1a5f: $e1
    ld [c], a                                     ; $1a60: $e2
    ld d, b                                       ; $1a61: $50
    add d                                         ; $1a62: $82

Jump_000_1a63:
    sub e                                         ; $1a63: $93
    ld d, b                                       ; $1a64: $50
    add e                                         ; $1a65: $83
    sub c                                         ; $1a66: $91
    add h                                         ; $1a67: $84
    sub d                                         ; $1a68: $92

Jump_000_1a69:
    add sp, $50                                   ; $1a69: $e8 $50
    adc a                                         ; $1a6b: $8f
    adc [hl]                                      ; $1a6c: $8e
    adc d                                         ; $1a6d: $8a
    cp h                                          ; $1a6e: $bc
    ld d, b                                       ; $1a6f: $50
    ld a, a                                       ; $1a70: $7f
    and h                                         ; $1a71: $a4
    xor l                                         ; $1a72: $ad
    xor l                                         ; $1a73: $ad
    and h                                         ; $1a74: $a4
    xor h                                         ; $1a75: $ac
    xor b                                         ; $1a76: $a8
    ld d, b                                       ; $1a77: $50

Jump_000_1a78:
    push de                                       ; $1a78: $d5
    ld b, h                                       ; $1a79: $44
    ld c, l                                       ; $1a7a: $4d
    ld hl, $1a88                                  ; $1a7b: $21 $88 $1a
    call Call_000_1b3c                            ; $1a7e: $cd $3c $1b
    ld h, b                                       ; $1a81: $60
    ld l, c                                       ; $1a82: $69
    pop de                                        ; $1a83: $d1
    inc de                                        ; $1a84: $13
    jp Jump_000_1953                              ; $1a85: $c3 $53 $19


    rla                                           ; $1a88: $17
    add b                                         ; $1a89: $80
    ld l, c                                       ; $1a8a: $69

Call_000_1a8b:
    ld [hl+], a                                   ; $1a8b: $22
    ld d, b                                       ; $1a8c: $50

Jump_000_1a8d:
    ld [hl], $e8                                  ; $1a8d: $36 $e8
    pop hl                                        ; $1a8f: $e1
    ret                                           ; $1a90: $c9


Jump_000_1a91:
    ld a, [$d130]                                 ; $1a91: $fa $30 $d1
    cp $04                                        ; $1a94: $fe $04
    jp z, Jump_000_1a9e                           ; $1a96: $ca $9e $1a

    ld a, $ee                                     ; $1a99: $3e $ee
    ld [$c4f2], a                                 ; $1a9b: $ea $f2 $c4

Jump_000_1a9e:
    call Call_000_1b36                            ; $1a9e: $cd $36 $1b
    call Call_000_38b5                            ; $1aa1: $cd $b5 $38
    ld a, $7f                                     ; $1aa4: $3e $7f
    ld [$c4f2], a                                 ; $1aa6: $ea $f2 $c4

Jump_000_1aa9:
    pop hl                                        ; $1aa9: $e1

Call_000_1aaa:
    ld de, $1aaf                                  ; $1aaa: $11 $af $1a
    dec de                                        ; $1aad: $1b
    ret                                           ; $1aae: $c9


    ld d, b                                       ; $1aaf: $50

Jump_000_1ab0:
    push de                                       ; $1ab0: $d5
    ld a, $ee                                     ; $1ab1: $3e $ee
    ld [$c4f2], a                                 ; $1ab3: $ea $f2 $c4
    call Call_000_1b36                            ; $1ab6: $cd $36 $1b
    call Call_000_38b5                            ; $1ab9: $cd $b5 $38
    ld hl, $c4a5                                  ; $1abc: $21 $a5 $c4
    ld bc, $0412                                  ; $1abf: $01 $12 $04
    call Call_000_18c1                            ; $1ac2: $cd $c1 $18
    ld c, $14                                     ; $1ac5: $0e $14
    call Call_000_3756                            ; $1ac7: $cd $56 $37
    pop de                                        ; $1aca: $d1
    ld hl, $c4b9                                  ; $1acb: $21 $b9 $c4
    jp Jump_000_19e5                              ; $1ace: $c3 $e5 $19


Jump_000_1ad1:
    push de                                       ; $1ad1: $d5
    ld a, $ee                                     ; $1ad2: $3e $ee
    ld [$c4f2], a                                 ; $1ad4: $ea $f2 $c4
    call Call_000_1b36                            ; $1ad7: $cd $36 $1b
    call Call_000_38b5                            ; $1ada: $cd $b5 $38
    ld hl, $c469                                  ; $1add: $21 $69 $c4
    ld bc, $0712                                  ; $1ae0: $01 $12 $07
    call Call_000_18c1                            ; $1ae3: $cd $c1 $18
    ld c, $14                                     ; $1ae6: $0e $14
    call Call_000_3756                            ; $1ae8: $cd $56 $37
    pop de                                        ; $1aeb: $d1
    pop hl                                        ; $1aec: $e1
    ld hl, $c47d                                  ; $1aed: $21 $7d $c4
    push hl                                       ; $1af0: $e5
    jp Jump_000_19e5                              ; $1af1: $c3 $e5 $19


Call_000_1af4:
Jump_000_1af4:
    ld a, $ee                                     ; $1af4: $3e $ee
    ld [$c4f2], a                                 ; $1af6: $ea $f2 $c4
    call Call_000_1b36                            ; $1af9: $cd $36 $1b
    push de                                       ; $1afc: $d5
    call Call_000_38b5                            ; $1afd: $cd $b5 $38

Jump_000_1b00:
    pop de                                        ; $1b00: $d1
    ld a, $7f                                     ; $1b01: $3e $7f
    ld [$c4f2], a                                 ; $1b03: $ea $f2 $c4

Jump_000_1b06:
    push de                                       ; $1b06: $d5
    call Call_000_1b14                            ; $1b07: $cd $14 $1b
    call Call_000_1b14                            ; $1b0a: $cd $14 $1b
    ld hl, $c4e1                                  ; $1b0d: $21 $e1 $c4
    pop de                                        ; $1b10: $d1
    jp Jump_000_19e5                              ; $1b11: $c3 $e5 $19


Call_000_1b14:
    ld hl, $c4b8                                  ; $1b14: $21 $b8 $c4
    ld de, $c4a4                                  ; $1b17: $11 $a4 $c4
    ld b, $3c                                     ; $1b1a: $06 $3c

jr_000_1b1c:
    ld a, [hl+]                                   ; $1b1c: $2a
    ld [de], a                                    ; $1b1d: $12
    inc de                                        ; $1b1e: $13
    dec b                                         ; $1b1f: $05
    jr nz, jr_000_1b1c                            ; $1b20: $20 $fa

    ld hl, $c4e1                                  ; $1b22: $21 $e1 $c4
    ld a, $7f                                     ; $1b25: $3e $7f
    ld b, $12                                     ; $1b27: $06 $12

jr_000_1b29:
    ld [hl+], a                                   ; $1b29: $22
    dec b                                         ; $1b2a: $05
    jr nz, jr_000_1b29                            ; $1b2b: $20 $fc

    ld b, $05                                     ; $1b2d: $06 $05

jr_000_1b2f:
    call Call_000_20ab                            ; $1b2f: $cd $ab $20
    dec b                                         ; $1b32: $05
    jr nz, jr_000_1b2f                            ; $1b33: $20 $fa

    ret                                           ; $1b35: $c9


Call_000_1b36:
    push bc                                       ; $1b36: $c5
    call Call_000_3df4                            ; $1b37: $cd $f4 $3d
    pop bc                                        ; $1b3a: $c1
    ret                                           ; $1b3b: $c9


Call_000_1b3c:
Jump_000_1b3c:
    ld a, [$d35d]                                 ; $1b3c: $fa $5d $d3
    push af                                       ; $1b3f: $f5
    set 1, a                                      ; $1b40: $cb $cf
    ld e, a                                       ; $1b42: $5f
    ldh a, [$f4]                                  ; $1b43: $f0 $f4
    xor e                                         ; $1b45: $ab
    ld [$d35d], a                                 ; $1b46: $ea $5d $d3
    ld a, c                                       ; $1b49: $79
    ld [$cc3a], a                                 ; $1b4a: $ea $3a $cc
    ld a, b                                       ; $1b4d: $78
    ld [$cc3b], a                                 ; $1b4e: $ea $3b $cc

Jump_000_1b51:
jr_000_1b51:
    ld a, [hl+]                                   ; $1b51: $2a
    cp $50                                        ; $1b52: $fe $50
    jr nz, jr_000_1b5b                            ; $1b54: $20 $05

    pop af                                        ; $1b56: $f1
    ld [$d35d], a                                 ; $1b57: $ea $5d $d3
    ret                                           ; $1b5a: $c9


jr_000_1b5b:
    push hl                                       ; $1b5b: $e5
    cp $17                                        ; $1b5c: $fe $17
    jp z, Jump_000_1c9f                           ; $1b5e: $ca $9f $1c

    cp $0e                                        ; $1b61: $fe $0e
    jp nc, Jump_000_1c2d                          ; $1b63: $d2 $2d $1c

    ld hl, $1cbd                                  ; $1b66: $21 $bd $1c
    push bc                                       ; $1b69: $c5
    add a                                         ; $1b6a: $87
    ld b, $00                                     ; $1b6b: $06 $00
    ld c, a                                       ; $1b6d: $4f
    add hl, bc                                    ; $1b6e: $09
    pop bc                                        ; $1b6f: $c1
    ld a, [hl+]                                   ; $1b70: $2a
    ld h, [hl]                                    ; $1b71: $66
    ld l, a                                       ; $1b72: $6f
    jp hl                                         ; $1b73: $e9


    pop hl                                        ; $1b74: $e1
    ld a, [hl+]                                   ; $1b75: $2a
    ld e, a                                       ; $1b76: $5f
    ld a, [hl+]                                   ; $1b77: $2a
    ld d, a                                       ; $1b78: $57
    ld a, [hl+]                                   ; $1b79: $2a
    ld b, a                                       ; $1b7a: $47
    ld a, [hl+]                                   ; $1b7b: $2a
    ld c, a                                       ; $1b7c: $4f
    push hl                                       ; $1b7d: $e5
    ld h, d                                       ; $1b7e: $62
    ld l, e                                       ; $1b7f: $6b
    call Call_000_191f                            ; $1b80: $cd $1f $19
    pop hl                                        ; $1b83: $e1
    jr jr_000_1b51                                ; $1b84: $18 $cb

    pop hl                                        ; $1b86: $e1
    ld d, h                                       ; $1b87: $54
    ld e, l                                       ; $1b88: $5d
    ld h, b                                       ; $1b89: $60
    ld l, c                                       ; $1b8a: $69
    call Call_000_1952                            ; $1b8b: $cd $52 $19
    ld h, d                                       ; $1b8e: $62
    ld l, e                                       ; $1b8f: $6b
    inc hl                                        ; $1b90: $23
    jr jr_000_1b51                                ; $1b91: $18 $be

    pop hl                                        ; $1b93: $e1
    ld a, [hl+]                                   ; $1b94: $2a
    ld e, a                                       ; $1b95: $5f
    ld a, [hl+]                                   ; $1b96: $2a
    ld d, a                                       ; $1b97: $57
    push hl                                       ; $1b98: $e5
    ld h, b                                       ; $1b99: $60
    ld l, c                                       ; $1b9a: $69
    call Call_000_1952                            ; $1b9b: $cd $52 $19
    pop hl                                        ; $1b9e: $e1
    jr jr_000_1b51                                ; $1b9f: $18 $b0

    pop hl                                        ; $1ba1: $e1
    ld a, [hl+]                                   ; $1ba2: $2a
    ld e, a                                       ; $1ba3: $5f
    ld a, [hl+]                                   ; $1ba4: $2a
    ld d, a                                       ; $1ba5: $57
    ld a, [hl+]                                   ; $1ba6: $2a
    push hl                                       ; $1ba7: $e5
    ld h, b                                       ; $1ba8: $60
    ld l, c                                       ; $1ba9: $69
    ld c, a                                       ; $1baa: $4f
    call Call_000_15ca                            ; $1bab: $cd $ca $15
    ld b, h                                       ; $1bae: $44
    ld c, l                                       ; $1baf: $4d
    pop hl                                        ; $1bb0: $e1
    jr jr_000_1b51                                ; $1bb1: $18 $9e

    pop hl                                        ; $1bb3: $e1
    ld a, [hl+]                                   ; $1bb4: $2a
    ld [$cc3a], a                                 ; $1bb5: $ea $3a $cc
    ld c, a                                       ; $1bb8: $4f
    ld a, [hl+]                                   ; $1bb9: $2a
    ld [$cc3b], a                                 ; $1bba: $ea $3b $cc
    ld b, a                                       ; $1bbd: $47

Jump_000_1bbe:
    jp Jump_000_1b51                              ; $1bbe: $c3 $51 $1b


    pop hl                                        ; $1bc1: $e1
    ld bc, $c4e1                                  ; $1bc2: $01 $e1 $c4
    jp Jump_000_1b51                              ; $1bc5: $c3 $51 $1b


    ld a, [$d130]                                 ; $1bc8: $fa $30 $d1
    cp $04                                        ; $1bcb: $fe $04
    jp z, Jump_000_1c96                           ; $1bcd: $ca $96 $1c

    ld a, $ee                                     ; $1bd0: $3e $ee
    ld [$c4f2], a                                 ; $1bd2: $ea $f2 $c4
    push bc                                       ; $1bd5: $c5
    call Call_000_38b5                            ; $1bd6: $cd $b5 $38
    pop bc                                        ; $1bd9: $c1
    ld a, $7f                                     ; $1bda: $3e $7f
    ld [$c4f2], a                                 ; $1bdc: $ea $f2 $c4
    pop hl                                        ; $1bdf: $e1
    jp Jump_000_1b51                              ; $1be0: $c3 $51 $1b


    ld a, $7f                                     ; $1be3: $3e $7f
    ld [$c4f2], a                                 ; $1be5: $ea $f2 $c4
    call Call_000_1b14                            ; $1be8: $cd $14 $1b
    call Call_000_1b14                            ; $1beb: $cd $14 $1b
    pop hl                                        ; $1bee: $e1
    ld bc, $c4e1                                  ; $1bef: $01 $e1 $c4
    jp Jump_000_1b51                              ; $1bf2: $c3 $51 $1b


    pop hl                                        ; $1bf5: $e1
    ld de, $1b51                                  ; $1bf6: $11 $51 $1b
    push de                                       ; $1bf9: $d5
    jp hl                                         ; $1bfa: $e9


    pop hl                                        ; $1bfb: $e1
    ld a, [hl+]                                   ; $1bfc: $2a
    ld e, a                                       ; $1bfd: $5f
    ld a, [hl+]                                   ; $1bfe: $2a
    ld d, a                                       ; $1bff: $57
    ld a, [hl+]                                   ; $1c00: $2a
    push hl                                       ; $1c01: $e5
    ld h, b                                       ; $1c02: $60
    ld l, c                                       ; $1c03: $69
    ld b, a                                       ; $1c04: $47
    and $0f                                       ; $1c05: $e6 $0f
    ld c, a                                       ; $1c07: $4f
    ld a, b                                       ; $1c08: $78
    and $f0                                       ; $1c09: $e6 $f0
    swap a                                        ; $1c0b: $cb $37
    set 6, a                                      ; $1c0d: $cb $f7
    ld b, a                                       ; $1c0f: $47
    call Call_000_3c7c                            ; $1c10: $cd $7c $3c
    ld b, h                                       ; $1c13: $44
    ld c, l                                       ; $1c14: $4d
    pop hl                                        ; $1c15: $e1
    jp Jump_000_1b51                              ; $1c16: $c3 $51 $1b


    push bc                                       ; $1c19: $c5
    call Call_000_019a                            ; $1c1a: $cd $9a $01
    ldh a, [$b4]                                  ; $1c1d: $f0 $b4
    and $03                                       ; $1c1f: $e6 $03

Call_000_1c21:
    jr nz, jr_000_1c28                            ; $1c21: $20 $05

    ld c, $1e                                     ; $1c23: $0e $1e
    call Call_000_3756                            ; $1c25: $cd $56 $37

jr_000_1c28:
    pop bc                                        ; $1c28: $c1
    pop hl                                        ; $1c29: $e1
    jp Jump_000_1b51                              ; $1c2a: $c3 $51 $1b


Jump_000_1c2d:
    pop hl                                        ; $1c2d: $e1
    push bc                                       ; $1c2e: $c5
    dec hl                                        ; $1c2f: $2b
    ld a, [hl+]                                   ; $1c30: $2a
    ld b, a                                       ; $1c31: $47
    push hl                                       ; $1c32: $e5
    ld hl, $1c60                                  ; $1c33: $21 $60 $1c

jr_000_1c36:
    ld a, [hl+]                                   ; $1c36: $2a
    cp b                                          ; $1c37: $b8
    jr z, jr_000_1c3d                             ; $1c38: $28 $03

    inc hl                                        ; $1c3a: $23
    jr jr_000_1c36                                ; $1c3b: $18 $f9

jr_000_1c3d:
    cp $14                                        ; $1c3d: $fe $14
    jr z, jr_000_1c55                             ; $1c3f: $28 $14

    cp $15                                        ; $1c41: $fe $15
    jr z, jr_000_1c55                             ; $1c43: $28 $10

    cp $16                                        ; $1c45: $fe $16
    jr z, jr_000_1c55                             ; $1c47: $28 $0c

    ld a, [hl]                                    ; $1c49: $7e
    call Call_000_23ad                            ; $1c4a: $cd $ad $23
    call Call_000_3765                            ; $1c4d: $cd $65 $37
    pop hl                                        ; $1c50: $e1
    pop bc                                        ; $1c51: $c1
    jp Jump_000_1b51                              ; $1c52: $c3 $51 $1b


jr_000_1c55:
    push de                                       ; $1c55: $d5
    ld a, [hl]                                    ; $1c56: $7e
    call Call_000_13d0                            ; $1c57: $cd $d0 $13
    pop de                                        ; $1c5a: $d1
    pop hl                                        ; $1c5b: $e1
    pop bc                                        ; $1c5c: $c1
    jp Jump_000_1b51                              ; $1c5d: $c3 $51 $1b


    dec bc                                        ; $1c60: $0b
    add [hl]                                      ; $1c61: $86
    ld [de], a                                    ; $1c62: $12

Call_000_1c63:
    sbc d                                         ; $1c63: $9a
    ld c, $91                                     ; $1c64: $0e $91
    rrca                                          ; $1c66: $0f
    add [hl]                                      ; $1c67: $86
    db $10                                        ; $1c68: $10
    adc c                                         ; $1c69: $89

Call_000_1c6a:
    ld de, $1394                                  ; $1c6a: $11 $94 $13
    sbc b                                         ; $1c6d: $98
    inc d                                         ; $1c6e: $14
    xor b                                         ; $1c6f: $a8
    dec d                                         ; $1c70: $15
    sub a                                         ; $1c71: $97
    ld d, $78                                     ; $1c72: $16 $78
    pop hl                                        ; $1c74: $e1
    ld a, [hl+]                                   ; $1c75: $2a
    ld d, a                                       ; $1c76: $57
    push hl                                       ; $1c77: $e5
    ld h, b                                       ; $1c78: $60
    ld l, c                                       ; $1c79: $69

jr_000_1c7a:
    ld a, $75                                     ; $1c7a: $3e $75
    ld [hl+], a                                   ; $1c7c: $22
    push de                                       ; $1c7d: $d5
    call Call_000_019a                            ; $1c7e: $cd $9a $01
    pop de                                        ; $1c81: $d1
    ldh a, [$b4]                                  ; $1c82: $f0 $b4
    and $03                                       ; $1c84: $e6 $03
    jr nz, jr_000_1c8d                            ; $1c86: $20 $05

    ld c, $0a                                     ; $1c88: $0e $0a
    call Call_000_3756                            ; $1c8a: $cd $56 $37

jr_000_1c8d:
    dec d                                         ; $1c8d: $15

Call_000_1c8e:
    jr nz, jr_000_1c7a                            ; $1c8e: $20 $ea

    ld b, h                                       ; $1c90: $44
    ld c, l                                       ; $1c91: $4d
    pop hl                                        ; $1c92: $e1
    jp Jump_000_1b51                              ; $1c93: $c3 $51 $1b


Jump_000_1c96:
    push bc                                       ; $1c96: $c5
    call Call_000_38b5                            ; $1c97: $cd $b5 $38
    pop bc                                        ; $1c9a: $c1
    pop hl                                        ; $1c9b: $e1
    jp Jump_000_1b51                              ; $1c9c: $c3 $51 $1b


Jump_000_1c9f:
    pop hl                                        ; $1c9f: $e1
    ldh a, [$b8]                                  ; $1ca0: $f0 $b8
    push af                                       ; $1ca2: $f5
    ld a, [hl+]                                   ; $1ca3: $2a
    ld e, a                                       ; $1ca4: $5f
    ld a, [hl+]                                   ; $1ca5: $2a
    ld d, a                                       ; $1ca6: $57
    ld a, [hl+]                                   ; $1ca7: $2a

Jump_000_1ca8:
    ldh [$b8], a                                  ; $1ca8: $e0 $b8
    ld [$2000], a                                 ; $1caa: $ea $00 $20
    push hl                                       ; $1cad: $e5
    ld l, e                                       ; $1cae: $6b
    ld h, d                                       ; $1caf: $62
    call Call_000_1b3c                            ; $1cb0: $cd $3c $1b
    pop hl                                        ; $1cb3: $e1
    pop af                                        ; $1cb4: $f1
    ldh [$b8], a                                  ; $1cb5: $e0 $b8
    ld [$2000], a                                 ; $1cb7: $ea $00 $20
    jp Jump_000_1b51                              ; $1cba: $c3 $51 $1b


    add [hl]                                      ; $1cbd: $86
    dec de                                        ; $1cbe: $1b
    sub e                                         ; $1cbf: $93
    dec de                                        ; $1cc0: $1b
    and c                                         ; $1cc1: $a1
    dec de                                        ; $1cc2: $1b
    or e                                          ; $1cc3: $b3
    dec de                                        ; $1cc4: $1b
    ld [hl], h                                    ; $1cc5: $74

Jump_000_1cc6:
    dec de                                        ; $1cc6: $1b

Call_000_1cc7:
    pop bc                                        ; $1cc7: $c1
    dec de                                        ; $1cc8: $1b
    ret z                                         ; $1cc9: $c8

    dec de                                        ; $1cca: $1b
    db $e3                                        ; $1ccb: $e3
    dec de                                        ; $1ccc: $1b

Call_000_1ccd:
    push af                                       ; $1ccd: $f5
    dec de                                        ; $1cce: $1b
    ei                                            ; $1ccf: $fb
    dec de                                        ; $1cd0: $1b
    add hl, de                                    ; $1cd1: $19
    inc e                                         ; $1cd2: $1c
    dec l                                         ; $1cd3: $2d
    inc e                                         ; $1cd4: $1c

Call_000_1cd5:
    ld [hl], h                                    ; $1cd5: $74
    inc e                                         ; $1cd6: $1c
    sub [hl]                                      ; $1cd7: $96
    inc e                                         ; $1cd8: $1c

Call_000_1cd9:
    xor a                                         ; $1cd9: $af
    srl h                                         ; $1cda: $cb $3c
    rr a                                          ; $1cdc: $cb $1f
    srl h                                         ; $1cde: $cb $3c
    rr a                                          ; $1ce0: $cb $1f
    srl h                                         ; $1ce2: $cb $3c
    rr a                                          ; $1ce4: $cb $1f
    or l                                          ; $1ce6: $b5
    ld l, a                                       ; $1ce7: $6f
    ld a, b                                       ; $1ce8: $78
    or h                                          ; $1ce9: $b4
    ld h, a                                       ; $1cea: $67
    ret                                           ; $1ceb: $c9


Call_000_1cec:
    ld a, $7f                                     ; $1cec: $3e $7f
    jr jr_000_1cf1                                ; $1cee: $18 $01

    ld a, l                                       ; $1cf0: $7d

jr_000_1cf1:
    ld de, $0400                                  ; $1cf1: $11 $00 $04
    ld l, e                                       ; $1cf4: $6b

jr_000_1cf5:
    ld [hl+], a                                   ; $1cf5: $22
    dec e                                         ; $1cf6: $1d
    jr nz, jr_000_1cf5                            ; $1cf7: $20 $fc

    dec d                                         ; $1cf9: $15
    jr nz, jr_000_1cf5                            ; $1cfa: $20 $f9

Call_000_1cfc:
    ret                                           ; $1cfc: $c9


Call_000_1cfd:
    ldh a, [$d0]                                  ; $1cfd: $f0 $d0
    and a                                         ; $1cff: $a7
    ret z                                         ; $1d00: $c8

    ld b, a                                       ; $1d01: $47
    xor a                                         ; $1d02: $af
    ldh [$d0], a                                  ; $1d03: $e0 $d0
    dec b                                         ; $1d05: $05
    jr nz, jr_000_1d2c                            ; $1d06: $20 $24

    ld hl, $cbfc                                  ; $1d08: $21 $fc $cb
    ldh a, [$d1]                                  ; $1d0b: $f0 $d1

Call_000_1d0d:
    ld e, a                                       ; $1d0d: $5f
    ldh a, [$d2]                                  ; $1d0e: $f0 $d2
    ld d, a                                       ; $1d10: $57
    ld c, $12                                     ; $1d11: $0e $12

jr_000_1d13:
    ld a, [hl+]                                   ; $1d13: $2a
    ld [de], a                                    ; $1d14: $12
    inc de                                        ; $1d15: $13

Jump_000_1d16:
    ld a, [hl+]                                   ; $1d16: $2a

Call_000_1d17:
    ld [de], a                                    ; $1d17: $12
    ld a, $1f                                     ; $1d18: $3e $1f
    add e                                         ; $1d1a: $83
    ld e, a                                       ; $1d1b: $5f
    jr nc, jr_000_1d1f                            ; $1d1c: $30 $01

    inc d                                         ; $1d1e: $14

jr_000_1d1f:
    ld a, d                                       ; $1d1f: $7a
    and $03                                       ; $1d20: $e6 $03
    or $98                                        ; $1d22: $f6 $98
    ld d, a                                       ; $1d24: $57
    dec c                                         ; $1d25: $0d
    jr nz, jr_000_1d13                            ; $1d26: $20 $eb

    xor a                                         ; $1d28: $af
    ldh [$d0], a                                  ; $1d29: $e0 $d0
    ret                                           ; $1d2b: $c9


jr_000_1d2c:
    ld hl, $cbfc                                  ; $1d2c: $21 $fc $cb
    ldh a, [$d1]                                  ; $1d2f: $f0 $d1
    ld e, a                                       ; $1d31: $5f
    ldh a, [$d2]                                  ; $1d32: $f0 $d2
    ld d, a                                       ; $1d34: $57
    push de                                       ; $1d35: $d5
    call Call_000_1d3e                            ; $1d36: $cd $3e $1d
    pop de                                        ; $1d39: $d1
    ld a, $20                                     ; $1d3a: $3e $20
    add e                                         ; $1d3c: $83
    ld e, a                                       ; $1d3d: $5f

Call_000_1d3e:
    ld c, $0a                                     ; $1d3e: $0e $0a

jr_000_1d40:
    ld a, [hl+]                                   ; $1d40: $2a
    ld [de], a                                    ; $1d41: $12
    inc de                                        ; $1d42: $13

Call_000_1d43:
    ld a, [hl+]                                   ; $1d43: $2a
    ld [de], a                                    ; $1d44: $12
    ld a, e                                       ; $1d45: $7b
    inc a                                         ; $1d46: $3c

Jump_000_1d47:
    and $1f                                       ; $1d47: $e6 $1f
    ld b, a                                       ; $1d49: $47
    ld a, e                                       ; $1d4a: $7b
    and $e0                                       ; $1d4b: $e6 $e0
    or b                                          ; $1d4d: $b0
    ld e, a                                       ; $1d4e: $5f
    dec c                                         ; $1d4f: $0d
    jr nz, jr_000_1d40                            ; $1d50: $20 $ee

    ret                                           ; $1d52: $c9


Call_000_1d53:
    ldh a, [$ba]                                  ; $1d53: $f0 $ba
    and a                                         ; $1d55: $a7
    ret z                                         ; $1d56: $c8

    ld hl, sp+$00                                 ; $1d57: $f8 $00
    ld a, h                                       ; $1d59: $7c
    ldh [$bf], a                                  ; $1d5a: $e0 $bf
    ld a, l                                       ; $1d5c: $7d
    ldh [$c0], a                                  ; $1d5d: $e0 $c0
    ldh a, [$bb]                                  ; $1d5f: $f0 $bb
    and a                                         ; $1d61: $a7
    jr z, jr_000_1d78                             ; $1d62: $28 $14

    dec a                                         ; $1d64: $3d
    jr z, jr_000_1d86                             ; $1d65: $28 $1f

Call_000_1d67:
    ld hl, $c490                                  ; $1d67: $21 $90 $c4
    ld sp, hl                                     ; $1d6a: $f9
    ldh a, [$bd]                                  ; $1d6b: $f0 $bd
    ld h, a                                       ; $1d6d: $67
    ldh a, [$bc]                                  ; $1d6e: $f0 $bc
    ld l, a                                       ; $1d70: $6f
    ld de, $0180                                  ; $1d71: $11 $80 $01
    add hl, de                                    ; $1d74: $19
    xor a                                         ; $1d75: $af
    jr jr_000_1d96                                ; $1d76: $18 $1e

jr_000_1d78:
    ld hl, $c3a0                                  ; $1d78: $21 $a0 $c3
    ld sp, hl                                     ; $1d7b: $f9
    ldh a, [$bd]                                  ; $1d7c: $f0 $bd
    ld h, a                                       ; $1d7e: $67
    ldh a, [$bc]                                  ; $1d7f: $f0 $bc
    ld l, a                                       ; $1d81: $6f
    ld a, $01                                     ; $1d82: $3e $01
    jr jr_000_1d96                                ; $1d84: $18 $10

jr_000_1d86:
    ld hl, $c418                                  ; $1d86: $21 $18 $c4
    ld sp, hl                                     ; $1d89: $f9
    ldh a, [$bd]                                  ; $1d8a: $f0 $bd
    ld h, a                                       ; $1d8c: $67

Jump_000_1d8d:
    ldh a, [$bc]                                  ; $1d8d: $f0 $bc
    ld l, a                                       ; $1d8f: $6f
    ld de, $00c0                                  ; $1d90: $11 $c0 $00
    add hl, de                                    ; $1d93: $19
    ld a, $02                                     ; $1d94: $3e $02

jr_000_1d96:
    ldh [$bb], a                                  ; $1d96: $e0 $bb
    ld b, $06                                     ; $1d98: $06 $06

jr_000_1d9a:
    pop de                                        ; $1d9a: $d1
    ld [hl], e                                    ; $1d9b: $73
    inc l                                         ; $1d9c: $2c
    ld [hl], d                                    ; $1d9d: $72
    inc l                                         ; $1d9e: $2c
    pop de                                        ; $1d9f: $d1
    ld [hl], e                                    ; $1da0: $73
    inc l                                         ; $1da1: $2c
    ld [hl], d                                    ; $1da2: $72
    inc l                                         ; $1da3: $2c
    pop de                                        ; $1da4: $d1
    ld [hl], e                                    ; $1da5: $73
    inc l                                         ; $1da6: $2c
    ld [hl], d                                    ; $1da7: $72
    inc l                                         ; $1da8: $2c
    pop de                                        ; $1da9: $d1
    ld [hl], e                                    ; $1daa: $73
    inc l                                         ; $1dab: $2c
    ld [hl], d                                    ; $1dac: $72
    inc l                                         ; $1dad: $2c
    pop de                                        ; $1dae: $d1
    ld [hl], e                                    ; $1daf: $73
    inc l                                         ; $1db0: $2c
    ld [hl], d                                    ; $1db1: $72
    inc l                                         ; $1db2: $2c
    pop de                                        ; $1db3: $d1
    ld [hl], e                                    ; $1db4: $73
    inc l                                         ; $1db5: $2c
    ld [hl], d                                    ; $1db6: $72
    inc l                                         ; $1db7: $2c
    pop de                                        ; $1db8: $d1
    ld [hl], e                                    ; $1db9: $73
    inc l                                         ; $1dba: $2c
    ld [hl], d                                    ; $1dbb: $72
    inc l                                         ; $1dbc: $2c
    pop de                                        ; $1dbd: $d1
    ld [hl], e                                    ; $1dbe: $73
    inc l                                         ; $1dbf: $2c
    ld [hl], d                                    ; $1dc0: $72
    inc l                                         ; $1dc1: $2c
    pop de                                        ; $1dc2: $d1
    ld [hl], e                                    ; $1dc3: $73
    inc l                                         ; $1dc4: $2c
    ld [hl], d                                    ; $1dc5: $72
    inc l                                         ; $1dc6: $2c
    pop de                                        ; $1dc7: $d1
    ld [hl], e                                    ; $1dc8: $73
    inc l                                         ; $1dc9: $2c
    ld [hl], d                                    ; $1dca: $72
    ld a, $0d                                     ; $1dcb: $3e $0d
    add l                                         ; $1dcd: $85
    ld l, a                                       ; $1dce: $6f
    jr nc, jr_000_1dd2                            ; $1dcf: $30 $01

    inc h                                         ; $1dd1: $24

jr_000_1dd2:
    dec b                                         ; $1dd2: $05
    jr nz, jr_000_1d9a                            ; $1dd3: $20 $c5

    ldh a, [$bf]                                  ; $1dd5: $f0 $bf
    ld h, a                                       ; $1dd7: $67
    ldh a, [$c0]                                  ; $1dd8: $f0 $c0
    ld l, a                                       ; $1dda: $6f
    ld sp, hl                                     ; $1ddb: $f9
    ret                                           ; $1ddc: $c9


Call_000_1ddd:
    ldh a, [$c1]                                  ; $1ddd: $f0 $c1
    and a                                         ; $1ddf: $a7
    ret z                                         ; $1de0: $c8

    ld hl, sp+$00                                 ; $1de1: $f8 $00
    ld a, h                                       ; $1de3: $7c
    ldh [$bf], a                                  ; $1de4: $e0 $bf
    ld a, l                                       ; $1de6: $7d
    ldh [$c0], a                                  ; $1de7: $e0 $c0
    ldh a, [$c1]                                  ; $1de9: $f0 $c1
    ld l, a                                       ; $1deb: $6f
    ldh a, [$c2]                                  ; $1dec: $f0 $c2
    ld h, a                                       ; $1dee: $67
    ld sp, hl                                     ; $1def: $f9
    ldh a, [$c3]                                  ; $1df0: $f0 $c3
    ld l, a                                       ; $1df2: $6f
    ldh a, [$c4]                                  ; $1df3: $f0 $c4
    ld h, a                                       ; $1df5: $67
    ldh a, [$c5]                                  ; $1df6: $f0 $c5
    ld b, a                                       ; $1df8: $47
    xor a                                         ; $1df9: $af
    ldh [$c1], a                                  ; $1dfa: $e0 $c1
    jr jr_000_1d9a                                ; $1dfc: $18 $9c

Call_000_1dfe:
    ldh a, [$cb]                                  ; $1dfe: $f0 $cb
    and a                                         ; $1e00: $a7
    ret z                                         ; $1e01: $c8

    ld hl, sp+$00                                 ; $1e02: $f8 $00
    ld a, h                                       ; $1e04: $7c
    ldh [$bf], a                                  ; $1e05: $e0 $bf
    ld a, l                                       ; $1e07: $7d
    ldh [$c0], a                                  ; $1e08: $e0 $c0
    ldh a, [$cc]                                  ; $1e0a: $f0 $cc
    ld l, a                                       ; $1e0c: $6f

Jump_000_1e0d:
    ldh a, [$cd]                                  ; $1e0d: $f0 $cd
    ld h, a                                       ; $1e0f: $67
    ld sp, hl                                     ; $1e10: $f9
    ldh a, [$ce]                                  ; $1e11: $f0 $ce
    ld l, a                                       ; $1e13: $6f
    ldh a, [$cf]                                  ; $1e14: $f0 $cf
    ld h, a                                       ; $1e16: $67
    ldh a, [$cb]                                  ; $1e17: $f0 $cb
    ld b, a                                       ; $1e19: $47
    xor a                                         ; $1e1a: $af
    ldh [$cb], a                                  ; $1e1b: $e0 $cb

jr_000_1e1d:
    pop de                                        ; $1e1d: $d1
    ld [hl], e                                    ; $1e1e: $73
    inc l                                         ; $1e1f: $2c
    ld [hl], e                                    ; $1e20: $73
    inc l                                         ; $1e21: $2c
    ld [hl], d                                    ; $1e22: $72
    inc l                                         ; $1e23: $2c
    ld [hl], d                                    ; $1e24: $72
    inc l                                         ; $1e25: $2c
    pop de                                        ; $1e26: $d1
    ld [hl], e                                    ; $1e27: $73
    inc l                                         ; $1e28: $2c
    ld [hl], e                                    ; $1e29: $73
    inc l                                         ; $1e2a: $2c
    ld [hl], d                                    ; $1e2b: $72
    inc l                                         ; $1e2c: $2c
    ld [hl], d                                    ; $1e2d: $72
    inc l                                         ; $1e2e: $2c
    pop de                                        ; $1e2f: $d1
    ld [hl], e                                    ; $1e30: $73
    inc l                                         ; $1e31: $2c
    ld [hl], e                                    ; $1e32: $73
    inc l                                         ; $1e33: $2c
    ld [hl], d                                    ; $1e34: $72
    inc l                                         ; $1e35: $2c
    ld [hl], d                                    ; $1e36: $72
    inc l                                         ; $1e37: $2c
    pop de                                        ; $1e38: $d1
    ld [hl], e                                    ; $1e39: $73
    inc l                                         ; $1e3a: $2c
    ld [hl], e                                    ; $1e3b: $73
    inc l                                         ; $1e3c: $2c
    ld [hl], d                                    ; $1e3d: $72
    inc l                                         ; $1e3e: $2c
    ld [hl], d                                    ; $1e3f: $72
    inc hl                                        ; $1e40: $23
    dec b                                         ; $1e41: $05
    jr nz, jr_000_1e1d                            ; $1e42: $20 $d9

    ld a, l                                       ; $1e44: $7d
    ldh [$ce], a                                  ; $1e45: $e0 $ce
    ld a, h                                       ; $1e47: $7c
    ldh [$cf], a                                  ; $1e48: $e0 $cf
    ld hl, sp+$00                                 ; $1e4a: $f8 $00
    ld a, l                                       ; $1e4c: $7d
    ldh [$cc], a                                  ; $1e4d: $e0 $cc
    ld a, h                                       ; $1e4f: $7c
    ldh [$cd], a                                  ; $1e50: $e0 $cd
    ldh a, [$bf]                                  ; $1e52: $f0 $bf
    ld h, a                                       ; $1e54: $67
    ldh a, [$c0]                                  ; $1e55: $f0 $c0
    ld l, a                                       ; $1e57: $6f
    ld sp, hl                                     ; $1e58: $f9
    ret                                           ; $1e59: $c9


Call_000_1e5a:
    ldh a, [$c6]                                  ; $1e5a: $f0 $c6
    and a                                         ; $1e5c: $a7
    ret z                                         ; $1e5d: $c8

    ld hl, sp+$00                                 ; $1e5e: $f8 $00
    ld a, h                                       ; $1e60: $7c
    ldh [$bf], a                                  ; $1e61: $e0 $bf
    ld a, l                                       ; $1e63: $7d
    ldh [$c0], a                                  ; $1e64: $e0 $c0
    ldh a, [$c7]                                  ; $1e66: $f0 $c7

Jump_000_1e68:
    ld l, a                                       ; $1e68: $6f
    ldh a, [$c8]                                  ; $1e69: $f0 $c8
    ld h, a                                       ; $1e6b: $67
    ld sp, hl                                     ; $1e6c: $f9
    ldh a, [$c9]                                  ; $1e6d: $f0 $c9
    ld l, a                                       ; $1e6f: $6f
    ldh a, [$ca]                                  ; $1e70: $f0 $ca
    ld h, a                                       ; $1e72: $67
    ldh a, [$c6]                                  ; $1e73: $f0 $c6
    ld b, a                                       ; $1e75: $47
    xor a                                         ; $1e76: $af
    ldh [$c6], a                                  ; $1e77: $e0 $c6

jr_000_1e79:
    pop de                                        ; $1e79: $d1
    ld [hl], e                                    ; $1e7a: $73
    inc l                                         ; $1e7b: $2c
    ld [hl], d                                    ; $1e7c: $72
    inc l                                         ; $1e7d: $2c
    pop de                                        ; $1e7e: $d1
    ld [hl], e                                    ; $1e7f: $73
    inc l                                         ; $1e80: $2c
    ld [hl], d                                    ; $1e81: $72
    inc l                                         ; $1e82: $2c
    pop de                                        ; $1e83: $d1
    ld [hl], e                                    ; $1e84: $73
    inc l                                         ; $1e85: $2c
    ld [hl], d                                    ; $1e86: $72
    inc l                                         ; $1e87: $2c
    pop de                                        ; $1e88: $d1
    ld [hl], e                                    ; $1e89: $73
    inc l                                         ; $1e8a: $2c
    ld [hl], d                                    ; $1e8b: $72
    inc l                                         ; $1e8c: $2c
    pop de                                        ; $1e8d: $d1
    ld [hl], e                                    ; $1e8e: $73
    inc l                                         ; $1e8f: $2c
    ld [hl], d                                    ; $1e90: $72
    inc l                                         ; $1e91: $2c
    pop de                                        ; $1e92: $d1
    ld [hl], e                                    ; $1e93: $73
    inc l                                         ; $1e94: $2c
    ld [hl], d                                    ; $1e95: $72
    inc l                                         ; $1e96: $2c
    pop de                                        ; $1e97: $d1
    ld [hl], e                                    ; $1e98: $73
    inc l                                         ; $1e99: $2c
    ld [hl], d                                    ; $1e9a: $72
    inc l                                         ; $1e9b: $2c
    pop de                                        ; $1e9c: $d1

Jump_000_1e9d:
    ld [hl], e                                    ; $1e9d: $73
    inc l                                         ; $1e9e: $2c
    ld [hl], d                                    ; $1e9f: $72
    inc hl                                        ; $1ea0: $23
    dec b                                         ; $1ea1: $05
    jr nz, jr_000_1e79                            ; $1ea2: $20 $d5

    ld a, l                                       ; $1ea4: $7d
    ldh [$c9], a                                  ; $1ea5: $e0 $c9

jr_000_1ea7:
    ld a, h                                       ; $1ea7: $7c
    ldh [$ca], a                                  ; $1ea8: $e0 $ca
    ld hl, sp+$00                                 ; $1eaa: $f8 $00
    ld a, l                                       ; $1eac: $7d
    ldh [$c7], a                                  ; $1ead: $e0 $c7
    ld a, h                                       ; $1eaf: $7c
    ldh [$c8], a                                  ; $1eb0: $e0 $c8
    ldh a, [$bf]                                  ; $1eb2: $f0 $bf
    ld h, a                                       ; $1eb4: $67
    ldh a, [$c0]                                  ; $1eb5: $f0 $c0

jr_000_1eb7:
    ld l, a                                       ; $1eb7: $6f
    ld sp, hl                                     ; $1eb8: $f9
    ret                                           ; $1eb9: $c9


Call_000_1eba:
    ldh a, [$d7]                                  ; $1eba: $f0 $d7
    and a                                         ; $1ebc: $a7
    ret z                                         ; $1ebd: $c8

    ldh a, [$d8]                                  ; $1ebe: $f0 $d8
    inc a                                         ; $1ec0: $3c
    ldh [$d8], a                                  ; $1ec1: $e0 $d8
    cp $14                                        ; $1ec3: $fe $14
    ret c                                         ; $1ec5: $d8

jr_000_1ec6:
    cp $15                                        ; $1ec6: $fe $15
    jr z, jr_000_1ef2                             ; $1ec8: $28 $28

    ld hl, $9140                                  ; $1eca: $21 $40 $91
    ld c, $10                                     ; $1ecd: $0e $10
    ld a, [$d08a]                                 ; $1ecf: $fa $8a $d0

Call_000_1ed2:
    inc a                                         ; $1ed2: $3c
    and $07                                       ; $1ed3: $e6 $07
    ld [$d08a], a                                 ; $1ed5: $ea $8a $d0
    and $04                                       ; $1ed8: $e6 $04
    jr nz, jr_000_1ee4                            ; $1eda: $20 $08

jr_000_1edc:
    ld a, [hl]                                    ; $1edc: $7e
    rrca                                          ; $1edd: $0f
    ld [hl+], a                                   ; $1ede: $22
    dec c                                         ; $1edf: $0d
    jr nz, jr_000_1edc                            ; $1ee0: $20 $fa

    jr jr_000_1eea                                ; $1ee2: $18 $06

jr_000_1ee4:
    ld a, [hl]                                    ; $1ee4: $7e
    rlca                                          ; $1ee5: $07
    ld [hl+], a                                   ; $1ee6: $22
    dec c                                         ; $1ee7: $0d
    jr nz, jr_000_1ee4                            ; $1ee8: $20 $fa

jr_000_1eea:
    ldh a, [$d7]                                  ; $1eea: $f0 $d7
    rrca                                          ; $1eec: $0f
    ret nc                                        ; $1eed: $d0

    xor a                                         ; $1eee: $af
    ldh [$d8], a                                  ; $1eef: $e0 $d8
    ret                                           ; $1ef1: $c9


jr_000_1ef2:
    xor a                                         ; $1ef2: $af
    ldh [$d8], a                                  ; $1ef3: $e0 $d8
    ld a, [$d08a]                                 ; $1ef5: $fa $8a $d0
    and $03                                       ; $1ef8: $e6 $03
    cp $02                                        ; $1efa: $fe $02
    ld hl, $1f15                                  ; $1efc: $21 $15 $1f
    jr c, jr_000_1f09                             ; $1eff: $38 $08

    ld hl, $1f25                                  ; $1f01: $21 $25 $1f

Jump_000_1f04:
    jr z, jr_000_1f09                             ; $1f04: $28 $03

    ld hl, $1f35                                  ; $1f06: $21 $35 $1f

jr_000_1f09:
    ld de, $9030                                  ; $1f09: $11 $30 $90
    ld c, $10                                     ; $1f0c: $0e $10

jr_000_1f0e:
    ld a, [hl+]                                   ; $1f0e: $2a
    ld [de], a                                    ; $1f0f: $12
    inc de                                        ; $1f10: $13
    dec c                                         ; $1f11: $0d
    jr nz, jr_000_1f0e                            ; $1f12: $20 $fa

    ret                                           ; $1f14: $c9


    add c                                         ; $1f15: $81

jr_000_1f16:
    nop                                           ; $1f16: $00
    nop                                           ; $1f17: $00
    jr jr_000_1f1a                                ; $1f18: $18 $00

jr_000_1f1a:
    inc h                                         ; $1f1a: $24

jr_000_1f1b:
    add l                                         ; $1f1b: $85
    ld e, d                                       ; $1f1c: $5a
    inc e                                         ; $1f1d: $1c
    ld b, d                                       ; $1f1e: $42
    jr jr_000_1ec6                                ; $1f1f: $18 $a5

    nop                                           ; $1f21: $00
    ld a, [hl]                                    ; $1f22: $7e
    add c                                         ; $1f23: $81
    jr jr_000_1ea7                                ; $1f24: $18 $81

    nop                                           ; $1f26: $00
    nop                                           ; $1f27: $00
    inc c                                         ; $1f28: $0c
    nop                                           ; $1f29: $00
    ld [de], a                                    ; $1f2a: $12
    add d                                         ; $1f2b: $82

Call_000_1f2c:
    dec l                                         ; $1f2c: $2d
    ld c, $e1                                     ; $1f2d: $0e $e1
    inc c                                         ; $1f2f: $0c
    ld [hl], e                                    ; $1f30: $73
    nop                                           ; $1f31: $00
    ld a, $81                                     ; $1f32: $3e $81
    jr jr_000_1eb7                                ; $1f34: $18 $81

    jr jr_000_1f38                                ; $1f36: $18 $00

jr_000_1f38:
    inc h                                         ; $1f38: $24
    inc b                                         ; $1f39: $04
    ld e, d                                       ; $1f3a: $5a
    sbc l                                         ; $1f3b: $9d
    ld b, d                                       ; $1f3c: $42
    jr @+$26                                      ; $1f3d: $18 $24

    nop                                           ; $1f3f: $00
    db $db                                        ; $1f40: $db
    nop                                           ; $1f41: $00
    ld a, [hl]                                    ; $1f42: $7e
    add c                                         ; $1f43: $81
    jr @-$31                                      ; $1f44: $18 $cd

    ld a, [bc]                                    ; $1f46: $0a
    jr nz, jr_000_1f16                            ; $1f47: $20 $cd

Jump_000_1f49:
    ld [bc], a                                    ; $1f49: $02
    ld a, $0e                                     ; $1f4a: $3e $0e
    jr nz, jr_000_1f1b                            ; $1f4c: $20 $cd

    ld d, [hl]                                    ; $1f4e: $56
    scf                                           ; $1f4f: $37

Jump_000_1f50:
    di                                            ; $1f50: $f3
    xor a                                         ; $1f51: $af

Jump_000_1f52:
    ldh [rIF], a                                  ; $1f52: $e0 $0f
    ldh [rIE], a                                  ; $1f54: $e0 $ff
    ldh [rSCX], a                                 ; $1f56: $e0 $43
    ldh [rSCY], a                                 ; $1f58: $e0 $42
    ldh [rSB], a                                  ; $1f5a: $e0 $01
    ldh [rSC], a                                  ; $1f5c: $e0 $02
    ldh [rWX], a                                  ; $1f5e: $e0 $4b
    ldh [rWY], a                                  ; $1f60: $e0 $4a

Jump_000_1f62:
    ldh [rTMA], a                                 ; $1f62: $e0 $06
    ldh [rTAC], a                                 ; $1f64: $e0 $07
    ldh [rBGP], a                                 ; $1f66: $e0 $47
    ldh [rOBP0], a                                ; $1f68: $e0 $48
    ldh [rOBP1], a                                ; $1f6a: $e0 $49
    ld a, $80                                     ; $1f6c: $3e $80
    ldh [rLCDC], a                                ; $1f6e: $e0 $40
    call Call_000_0061                            ; $1f70: $cd $61 $00
    ld sp, $dfff                                  ; $1f73: $31 $ff $df
    ld hl, $c000                                  ; $1f76: $21 $00 $c0
    ld bc, $2000                                  ; $1f79: $01 $00 $20

Call_000_1f7c:
jr_000_1f7c:
    ld [hl], $00                                  ; $1f7c: $36 $00
    inc hl                                        ; $1f7e: $23
    dec bc                                        ; $1f7f: $0b
    ld a, b                                       ; $1f80: $78
    or c                                          ; $1f81: $b1
    jr nz, jr_000_1f7c                            ; $1f82: $20 $f8

    call Call_000_2000                            ; $1f84: $cd $00 $20
    ld hl, $ff80                                  ; $1f87: $21 $80 $ff
    ld bc, $007f                                  ; $1f8a: $01 $7f $00
    call Call_000_36fd                            ; $1f8d: $cd $fd $36
    call Call_000_0082                            ; $1f90: $cd $82 $00
    ld a, $01                                     ; $1f93: $3e $01
    ldh [$b8], a                                  ; $1f95: $e0 $b8
    ld [$2000], a                                 ; $1f97: $ea $00 $20
    call $4c6a                                    ; $1f9a: $cd $6a $4c
    xor a                                         ; $1f9d: $af
    ldh [$d7], a                                  ; $1f9e: $e0 $d7
    ldh [rSTAT], a                                ; $1fa0: $e0 $41
    ldh [$ae], a                                  ; $1fa2: $e0 $ae
    ldh [$af], a                                  ; $1fa4: $e0 $af
    ldh [rIF], a                                  ; $1fa6: $e0 $0f
    ld a, $0d                                     ; $1fa8: $3e $0d

Jump_000_1faa:
    ldh [rIE], a                                  ; $1faa: $e0 $ff
    ld a, $90                                     ; $1fac: $3e $90
    ldh [$b0], a                                  ; $1fae: $e0 $b0
    ldh [rWY], a                                  ; $1fb0: $e0 $4a
    ld a, $07                                     ; $1fb2: $3e $07
    ldh [rWX], a                                  ; $1fb4: $e0 $4b
    ld a, $ff                                     ; $1fb6: $3e $ff
    ldh [$aa], a                                  ; $1fb8: $e0 $aa
    ld h, $98                                     ; $1fba: $26 $98
    call Call_000_1cec                            ; $1fbc: $cd $ec $1c
    ld h, $9c                                     ; $1fbf: $26 $9c
    call Call_000_1cec                            ; $1fc1: $cd $ec $1c
    ld a, $e3                                     ; $1fc4: $3e $e3
    ldh [rLCDC], a                                ; $1fc6: $e0 $40
    ld a, $10                                     ; $1fc8: $3e $10
    ldh [$8a], a                                  ; $1fca: $e0 $8a
    call Call_000_200a                            ; $1fcc: $cd $0a $20
    ei                                            ; $1fcf: $fb
    ld a, $40                                     ; $1fd0: $3e $40
    call Call_000_3e8a                            ; $1fd2: $cd $8a $3e
    ld a, $1f                                     ; $1fd5: $3e $1f
    ld [$c0ef], a                                 ; $1fd7: $ea $ef $c0
    ld [$c0f0], a                                 ; $1fda: $ea $f0 $c0
    ld a, $9c                                     ; $1fdd: $3e $9c
    ldh [$bd], a                                  ; $1fdf: $e0 $bd
    xor a                                         ; $1fe1: $af
    ldh [$bc], a                                  ; $1fe2: $e0 $bc
    dec a                                         ; $1fe4: $3d
    ld [$cfd0], a                                 ; $1fe5: $ea $d0 $cf
    ld a, $32                                     ; $1fe8: $3e $32
    call Call_000_3e8a                            ; $1fea: $cd $8a $3e
    call Call_000_0061                            ; $1fed: $cd $61 $00
    call Call_000_2000                            ; $1ff0: $cd $00 $20
    call Call_000_3df9                            ; $1ff3: $cd $f9 $3d
    call Call_000_0082                            ; $1ff6: $cd $82 $00
    ld a, $e3                                     ; $1ff9: $3e $e3
    ldh [rLCDC], a                                ; $1ffb: $e0 $40
    jp $42b7                                      ; $1ffd: $c3 $b7 $42


Call_000_2000:
    ld hl, $8000                                  ; $2000: $21 $00 $80
    ld bc, $2000                                  ; $2003: $01 $00 $20
    xor a                                         ; $2006: $af
    jp Jump_000_36fd                              ; $2007: $c3 $fd $36


Call_000_200a:
Jump_000_200a:
    ld a, $02                                     ; $200a: $3e $02
    ld [$c0ef], a                                 ; $200c: $ea $ef $c0
    ld [$c0f0], a                                 ; $200f: $ea $f0 $c0
    xor a                                         ; $2012: $af
    ld [$cfcc], a                                 ; $2013: $ea $cc $cf
    ld [$c0ee], a                                 ; $2016: $ea $ee $c0
    ld [$cfcf], a                                 ; $2019: $ea $cf $cf
    dec a                                         ; $201c: $3d
    jp Jump_000_23ad                              ; $201d: $c3 $ad $23


Jump_000_2020:
    push af                                       ; $2020: $f5
    push bc                                       ; $2021: $c5
    push de                                       ; $2022: $d5
    push hl                                       ; $2023: $e5
    ldh a, [$b8]                                  ; $2024: $f0 $b8
    ld [$d127], a                                 ; $2026: $ea $27 $d1
    ldh a, [$ae]                                  ; $2029: $f0 $ae
    ldh [rSCX], a                                 ; $202b: $e0 $43
    ldh a, [$af]                                  ; $202d: $f0 $af
    ldh [rSCY], a                                 ; $202f: $e0 $42
    ld a, [$d0a5]                                 ; $2031: $fa $a5 $d0
    and a                                         ; $2034: $a7
    jr nz, jr_000_203b                            ; $2035: $20 $04

    ldh a, [$b0]                                  ; $2037: $f0 $b0
    ldh [rWY], a                                  ; $2039: $e0 $4a

jr_000_203b:
    call Call_000_1d53                            ; $203b: $cd $53 $1d
    call Call_000_1ddd                            ; $203e: $cd $dd $1d
    call Call_000_1cfd                            ; $2041: $cd $fd $1c
    call Call_000_1e5a                            ; $2044: $cd $5a $1e
    call Call_000_1dfe                            ; $2047: $cd $fe $1d

Jump_000_204a:
    call Call_000_1eba                            ; $204a: $cd $ba $1e
    call $ff80                                    ; $204d: $cd $80 $ff
    ld a, $01                                     ; $2050: $3e $01

Jump_000_2052:
    ldh [$b8], a                                  ; $2052: $e0 $b8

Jump_000_2054:
    ld [$2000], a                                 ; $2054: $ea $00 $20

Call_000_2057:
    call $4b8c                                    ; $2057: $cd $8c $4b
    call Call_000_3e79                            ; $205a: $cd $79 $3e
    ldh a, [$d6]                                  ; $205d: $f0 $d6
    and a                                         ; $205f: $a7
    jr z, jr_000_2065                             ; $2060: $28 $03

Call_000_2062:
    xor a                                         ; $2062: $af
    ldh [$d6], a                                  ; $2063: $e0 $d6

jr_000_2065:
    ldh a, [$d5]                                  ; $2065: $f0 $d5
    and a                                         ; $2067: $a7
    jr z, jr_000_206d                             ; $2068: $28 $03

    dec a                                         ; $206a: $3d
    ldh [$d5], a                                  ; $206b: $e0 $d5

jr_000_206d:
    call Call_000_28c7                            ; $206d: $cd $c7 $28
    ld a, [$c0ef]                                 ; $2070: $fa $ef $c0
    ldh [$b8], a                                  ; $2073: $e0 $b8
    ld [$2000], a                                 ; $2075: $ea $00 $20
    cp $02                                        ; $2078: $fe $02
    jr nz, jr_000_2081                            ; $207a: $20 $05

    call $5103                                    ; $207c: $cd $03 $51
    jr jr_000_2090                                ; $207f: $18 $0f

jr_000_2081:
    cp $08                                        ; $2081: $fe $08
    jr nz, jr_000_208d                            ; $2083: $20 $08

    call $536e                                    ; $2085: $cd $6e $53
    call $587b                                    ; $2088: $cd $7b $58
    jr jr_000_2090                                ; $208b: $18 $03

jr_000_208d:
    call $5177                                    ; $208d: $cd $77 $51

jr_000_2090:
    ld b, $06                                     ; $2090: $06 $06
    ld hl, $4dee                                  ; $2092: $21 $ee $4d
    call Call_000_35f3                            ; $2095: $cd $f3 $35
    ldh a, [$f9]                                  ; $2098: $f0 $f9
    and a                                         ; $209a: $a7
    call z, Call_000_015f                         ; $209b: $cc $5f $01
    ld a, [$d127]                                 ; $209e: $fa $27 $d1
    ldh [$b8], a                                  ; $20a1: $e0 $b8
    ld [$2000], a                                 ; $20a3: $ea $00 $20
    pop hl                                        ; $20a6: $e1
    pop de                                        ; $20a7: $d1
    pop bc                                        ; $20a8: $c1
    pop af                                        ; $20a9: $f1
    reti                                          ; $20aa: $d9


Call_000_20ab:
Jump_000_20ab:
    ld a, $01                                     ; $20ab: $3e $01
    ldh [$d6], a                                  ; $20ad: $e0 $d6

jr_000_20af:
    db $76                                        ; $20af: $76
    ldh a, [$d6]                                  ; $20b0: $f0 $d6
    and a                                         ; $20b2: $a7
    jr nz, jr_000_20af                            ; $20b3: $20 $fa

    ret                                           ; $20b5: $c9


Call_000_20b6:
Jump_000_20b6:
    ld a, [$d362]                                 ; $20b6: $fa $62 $d3
    ld b, a                                       ; $20b9: $47
    ld hl, $2112                                  ; $20ba: $21 $12 $21
    ld a, l                                       ; $20bd: $7d
    sub b                                         ; $20be: $90
    ld l, a                                       ; $20bf: $6f
    jr nc, jr_000_20c3                            ; $20c0: $30 $01

    dec h                                         ; $20c2: $25

Call_000_20c3:
jr_000_20c3:
    ld a, [hl+]                                   ; $20c3: $2a
    ldh [rBGP], a                                 ; $20c4: $e0 $47

Call_000_20c6:
    ld a, [hl+]                                   ; $20c6: $2a
    ldh [rOBP0], a                                ; $20c7: $e0 $48
    ld a, [hl+]                                   ; $20c9: $2a
    ldh [rOBP1], a                                ; $20ca: $e0 $49
    ret                                           ; $20cc: $c9


Call_000_20cd:
    ld hl, $2109                                  ; $20cd: $21 $09 $21
    ld b, $04                                     ; $20d0: $06 $04
    jr jr_000_20d9                                ; $20d2: $18 $05

Call_000_20d4:
Jump_000_20d4:
    ld hl, $2118                                  ; $20d4: $21 $18 $21
    ld b, $03                                     ; $20d7: $06 $03

jr_000_20d9:
    ld a, [hl+]                                   ; $20d9: $2a
    ldh [rBGP], a                                 ; $20da: $e0 $47
    ld a, [hl+]                                   ; $20dc: $2a
    ldh [rOBP0], a                                ; $20dd: $e0 $48
    ld a, [hl+]                                   ; $20df: $2a
    ldh [rOBP1], a                                ; $20e0: $e0 $49
    ld c, $08                                     ; $20e2: $0e $08
    call Call_000_3756                            ; $20e4: $cd $56 $37
    dec b                                         ; $20e7: $05

Call_000_20e8:
    jr nz, jr_000_20d9                            ; $20e8: $20 $ef

    ret                                           ; $20ea: $c9


Call_000_20eb:
Jump_000_20eb:
    ld hl, $2114                                  ; $20eb: $21 $14 $21
    ld b, $04                                     ; $20ee: $06 $04
    jr jr_000_20f7                                ; $20f0: $18 $05

Call_000_20f2:
Jump_000_20f2:
    ld hl, $211d                                  ; $20f2: $21 $1d $21
    ld b, $03                                     ; $20f5: $06 $03

jr_000_20f7:
    ld a, [hl-]                                   ; $20f7: $3a
    ldh [rOBP1], a                                ; $20f8: $e0 $49
    ld a, [hl-]                                   ; $20fa: $3a
    ldh [rOBP0], a                                ; $20fb: $e0 $48
    ld a, [hl-]                                   ; $20fd: $3a
    ldh [rBGP], a                                 ; $20fe: $e0 $47

Call_000_2100:
Jump_000_2100:
    ld c, $08                                     ; $2100: $0e $08
    call Call_000_3756                            ; $2102: $cd $56 $37
    dec b                                         ; $2105: $05
    jr nz, jr_000_20f7                            ; $2106: $20 $ef

    ret                                           ; $2108: $c9


    rst $38                                       ; $2109: $ff
    rst $38                                       ; $210a: $ff
    rst $38                                       ; $210b: $ff
    cp $fe                                        ; $210c: $fe $fe
    ld hl, sp-$07                                 ; $210e: $f8 $f9
    db $e4                                        ; $2110: $e4
    db $e4                                        ; $2111: $e4
    db $e4                                        ; $2112: $e4

Jump_000_2113:
    ret nc                                        ; $2113: $d0

    ldh [$e4], a                                  ; $2114: $e0 $e4

Jump_000_2116:
    ret nc                                        ; $2116: $d0

    ldh [$90], a                                  ; $2117: $e0 $90
    add b                                         ; $2119: $80
    sub b                                         ; $211a: $90
    ld b, b                                       ; $211b: $40
    ld b, b                                       ; $211c: $40
    ld b, b                                       ; $211d: $40
    nop                                           ; $211e: $00
    nop                                           ; $211f: $00
    nop                                           ; $2120: $00

Jump_000_2121:
    push af                                       ; $2121: $f5
    push bc                                       ; $2122: $c5
    push de                                       ; $2123: $d5
    push hl                                       ; $2124: $e5

Jump_000_2125:
    ldh a, [$aa]                                  ; $2125: $f0 $aa
    inc a                                         ; $2127: $3c
    jr z, jr_000_213e                             ; $2128: $28 $14

    ldh a, [rSB]                                  ; $212a: $f0 $01
    ldh [$ad], a                                  ; $212c: $e0 $ad
    ldh a, [$ac]                                  ; $212e: $f0 $ac
    ldh [rSB], a                                  ; $2130: $e0 $01
    ldh a, [$aa]                                  ; $2132: $f0 $aa
    cp $02                                        ; $2134: $fe $02
    jr z, jr_000_215e                             ; $2136: $28 $26

    ld a, $80                                     ; $2138: $3e $80
    ldh [rSC], a                                  ; $213a: $e0 $02
    jr jr_000_215e                                ; $213c: $18 $20

jr_000_213e:
    ldh a, [rSB]                                  ; $213e: $f0 $01
    ldh [$ad], a                                  ; $2140: $e0 $ad
    ldh [$aa], a                                  ; $2142: $e0 $aa
    cp $02                                        ; $2144: $fe $02

Call_000_2146:
    jr z, jr_000_215b                             ; $2146: $28 $13

Call_000_2148:
    xor a                                         ; $2148: $af
    ldh [rSB], a                                  ; $2149: $e0 $01
    ld a, $03                                     ; $214b: $3e $03
    ldh [rDIV], a                                 ; $214d: $e0 $04

jr_000_214f:
    ldh a, [rDIV]                                 ; $214f: $f0 $04
    bit 7, a                                      ; $2151: $cb $7f
    jr nz, jr_000_214f                            ; $2153: $20 $fa

    ld a, $80                                     ; $2155: $3e $80
    ldh [rSC], a                                  ; $2157: $e0 $02
    jr jr_000_215e                                ; $2159: $18 $03

jr_000_215b:
    xor a                                         ; $215b: $af
    ldh [rSB], a                                  ; $215c: $e0 $01

Call_000_215e:
jr_000_215e:
    ld a, $01                                     ; $215e: $3e $01
    ldh [$a9], a                                  ; $2160: $e0 $a9
    ld a, $fe                                     ; $2162: $3e $fe
    ldh [$ac], a                                  ; $2164: $e0 $ac
    pop hl                                        ; $2166: $e1
    pop de                                        ; $2167: $d1
    pop bc                                        ; $2168: $c1
    pop af                                        ; $2169: $f1
    reti                                          ; $216a: $d9


Call_000_216b:
    ld a, $01                                     ; $216b: $3e $01

Jump_000_216d:
    ldh [$ab], a                                  ; $216d: $e0 $ab

jr_000_216f:
    ld a, [hl]                                    ; $216f: $7e
    ldh [$ac], a                                  ; $2170: $e0 $ac

Call_000_2172:
    call Call_000_2196                            ; $2172: $cd $96 $21
    push bc                                       ; $2175: $c5
    ld b, a                                       ; $2176: $47
    inc hl                                        ; $2177: $23
    ld a, $30                                     ; $2178: $3e $30

jr_000_217a:
    dec a                                         ; $217a: $3d
    jr nz, jr_000_217a                            ; $217b: $20 $fd

    ldh a, [$ab]                                  ; $217d: $f0 $ab
    and a                                         ; $217f: $a7
    ld a, b                                       ; $2180: $78

Call_000_2181:
    pop bc                                        ; $2181: $c1
    jr z, jr_000_218e                             ; $2182: $28 $0a

    dec hl                                        ; $2184: $2b
    cp $fd                                        ; $2185: $fe $fd
    jr nz, jr_000_216f                            ; $2187: $20 $e6

    xor a                                         ; $2189: $af
    ldh [$ab], a                                  ; $218a: $e0 $ab
    jr jr_000_216f                                ; $218c: $18 $e1

jr_000_218e:
    ld [de], a                                    ; $218e: $12

Jump_000_218f:
    inc de                                        ; $218f: $13
    dec bc                                        ; $2190: $0b
    ld a, b                                       ; $2191: $78
    or c                                          ; $2192: $b1
    jr nz, jr_000_216f                            ; $2193: $20 $da

Call_000_2195:
    ret                                           ; $2195: $c9


Call_000_2196:
Jump_000_2196:
    xor a                                         ; $2196: $af

Jump_000_2197:
    ldh [$a9], a                                  ; $2197: $e0 $a9
    ldh a, [$aa]                                  ; $2199: $f0 $aa
    cp $02                                        ; $219b: $fe $02
    jr nz, jr_000_21a3                            ; $219d: $20 $04

    ld a, $81                                     ; $219f: $3e $81
    ldh [rSC], a                                  ; $21a1: $e0 $02

jr_000_21a3:
    ldh a, [$a9]                                  ; $21a3: $f0 $a9
    and a                                         ; $21a5: $a7
    jr nz, jr_000_21ed                            ; $21a6: $20 $45

    ldh a, [$aa]                                  ; $21a8: $f0 $aa

Jump_000_21aa:
    cp $01                                        ; $21aa: $fe $01
    jr nz, jr_000_21c8                            ; $21ac: $20 $1a

    call Call_000_2233                            ; $21ae: $cd $33 $22
    jr z, jr_000_21c8                             ; $21b1: $28 $15

Call_000_21b3:
    call Call_000_222d                            ; $21b3: $cd $2d $22
    push hl                                       ; $21b6: $e5

Call_000_21b7:
    ld hl, $cc48                                  ; $21b7: $21 $48 $cc
    inc [hl]                                      ; $21ba: $34
    jr nz, jr_000_21bf                            ; $21bb: $20 $02

    dec hl                                        ; $21bd: $2b
    inc [hl]                                      ; $21be: $34

jr_000_21bf:
    pop hl                                        ; $21bf: $e1
    call Call_000_2233                            ; $21c0: $cd $33 $22
    jr nz, jr_000_21a3                            ; $21c3: $20 $de

    jp Jump_000_223b                              ; $21c5: $c3 $3b $22


jr_000_21c8:
    ldh a, [rIE]                                  ; $21c8: $f0 $ff
    and $0f                                       ; $21ca: $e6 $0f
    cp $08                                        ; $21cc: $fe $08
    jr nz, jr_000_21a3                            ; $21ce: $20 $d3

    ld a, [$d079]                                 ; $21d0: $fa $79 $d0
    dec a                                         ; $21d3: $3d
    ld [$d079], a                                 ; $21d4: $ea $79 $d0
    jr nz, jr_000_21a3                            ; $21d7: $20 $ca

    ld a, [$d07a]                                 ; $21d9: $fa $7a $d0
    dec a                                         ; $21dc: $3d
    ld [$d07a], a                                 ; $21dd: $ea $7a $d0
    jr nz, jr_000_21a3                            ; $21e0: $20 $c1

    ldh a, [$aa]                                  ; $21e2: $f0 $aa

Jump_000_21e4:
    cp $01                                        ; $21e4: $fe $01
    jr z, jr_000_21ed                             ; $21e6: $28 $05

    ld a, $ff                                     ; $21e8: $3e $ff

jr_000_21ea:
    dec a                                         ; $21ea: $3d
    jr nz, jr_000_21ea                            ; $21eb: $20 $fd

jr_000_21ed:
    xor a                                         ; $21ed: $af
    ldh [$a9], a                                  ; $21ee: $e0 $a9
    ldh a, [rIE]                                  ; $21f0: $f0 $ff
    and $0f                                       ; $21f2: $e6 $0f
    sub $08                                       ; $21f4: $d6 $08
    jr nz, jr_000_2200                            ; $21f6: $20 $08

    ld [$d079], a                                 ; $21f8: $ea $79 $d0
    ld a, $50                                     ; $21fb: $3e $50
    ld [$d07a], a                                 ; $21fd: $ea $7a $d0

jr_000_2200:
    ldh a, [$ad]                                  ; $2200: $f0 $ad
    cp $fe                                        ; $2202: $fe $fe
    ret nz                                        ; $2204: $c0

    call Call_000_2233                            ; $2205: $cd $33 $22
    jr z, jr_000_221b                             ; $2208: $28 $11

    push hl                                       ; $220a: $e5
    ld hl, $cc48                                  ; $220b: $21 $48 $cc
    ld a, [hl]                                    ; $220e: $7e

Jump_000_220f:
    dec a                                         ; $220f: $3d
    ld [hl-], a                                   ; $2210: $32
    inc a                                         ; $2211: $3c
    jr nz, jr_000_2215                            ; $2212: $20 $01

    dec [hl]                                      ; $2214: $35

jr_000_2215:
    pop hl                                        ; $2215: $e1
    call Call_000_2233                            ; $2216: $cd $33 $22
    jr z, jr_000_223b                             ; $2219: $28 $20

jr_000_221b:
    ldh a, [rIE]                                  ; $221b: $f0 $ff
    and $0f                                       ; $221d: $e6 $0f
    cp $08                                        ; $221f: $fe $08
    ld a, $fe                                     ; $2221: $3e $fe
    ret z                                         ; $2223: $c8

    ld a, [hl]                                    ; $2224: $7e
    ldh [$ac], a                                  ; $2225: $e0 $ac
    call Call_000_20ab                            ; $2227: $cd $ab $20
    jp Jump_000_2196                              ; $222a: $c3 $96 $21


Call_000_222d:
    ld a, $0f                                     ; $222d: $3e $0f

jr_000_222f:
    dec a                                         ; $222f: $3d
    jr nz, jr_000_222f                            ; $2230: $20 $fd

    ret                                           ; $2232: $c9


Call_000_2233:
    push hl                                       ; $2233: $e5
    ld hl, $cc47                                  ; $2234: $21 $47 $cc
    ld a, [hl+]                                   ; $2237: $2a
    or [hl]                                       ; $2238: $b6
    pop hl                                        ; $2239: $e1

Call_000_223a:
    ret                                           ; $223a: $c9


Jump_000_223b:
jr_000_223b:
    dec a                                         ; $223b: $3d
    ld [$cc47], a                                 ; $223c: $ea $47 $cc
    ld [$cc48], a                                 ; $223f: $ea $48 $cc
    ret                                           ; $2242: $c9


Call_000_2243:
    ld hl, $cc42                                  ; $2243: $21 $42 $cc

Jump_000_2246:
    ld de, $cc3d                                  ; $2246: $11 $3d $cc
    ld c, $02                                     ; $2249: $0e $02
    ld a, $01                                     ; $224b: $3e $01
    ldh [$ab], a                                  ; $224d: $e0 $ab

jr_000_224f:
    call Call_000_20ab                            ; $224f: $cd $ab $20

Jump_000_2252:
    ld a, [hl]                                    ; $2252: $7e
    ldh [$ac], a                                  ; $2253: $e0 $ac

Jump_000_2255:
    call Call_000_2196                            ; $2255: $cd $96 $21

Call_000_2258:
    ld b, a                                       ; $2258: $47

Call_000_2259:
    inc hl                                        ; $2259: $23
    ldh a, [$ab]                                  ; $225a: $f0 $ab

Jump_000_225c:
    and a                                         ; $225c: $a7

Call_000_225d:
    ld a, $00                                     ; $225d: $3e $00

Jump_000_225f:
    ldh [$ab], a                                  ; $225f: $e0 $ab
    jr nz, jr_000_224f                            ; $2261: $20 $ec

    ld a, b                                       ; $2263: $78
    ld [de], a                                    ; $2264: $12

Call_000_2265:
Jump_000_2265:
    inc de                                        ; $2265: $13

Jump_000_2266:
    dec c                                         ; $2266: $0d

Jump_000_2267:
    jr nz, jr_000_224f                            ; $2267: $20 $e6

Call_000_2269:
    ret                                           ; $2269: $c9


Call_000_226a:
    call Call_000_3736                            ; $226a: $cd $36 $37
    ld hl, $4c82                                  ; $226d: $21 $82 $4c
    ld b, $01                                     ; $2270: $06 $01
    call Call_000_35f3                            ; $2272: $cd $f3 $35
    call Call_000_227b                            ; $2275: $cd $7b $22
    jp Jump_000_3742                              ; $2278: $c3 $42 $37


Call_000_227b:
    ld a, $ff                                     ; $227b: $3e $ff
    ld [$cc3e], a                                 ; $227d: $ea $3e $cc

jr_000_2280:
    call Call_000_22bf                            ; $2280: $cd $bf $22
    call Call_000_20ab                            ; $2283: $cd $ab $20
    call Call_000_2233                            ; $2286: $cd $33 $22
    jr z, jr_000_229c                             ; $2289: $28 $11

    push hl                                       ; $228b: $e5
    ld hl, $cc48                                  ; $228c: $21 $48 $cc
    dec [hl]                                      ; $228f: $35
    jr nz, jr_000_229b                            ; $2290: $20 $09

    dec hl                                        ; $2292: $2b
    dec [hl]                                      ; $2293: $35
    jr nz, jr_000_229b                            ; $2294: $20 $05

    pop hl                                        ; $2296: $e1
    xor a                                         ; $2297: $af
    jp Jump_000_223b                              ; $2298: $c3 $3b $22


jr_000_229b:
    pop hl                                        ; $229b: $e1

jr_000_229c:
    ld a, [$cc3e]                                 ; $229c: $fa $3e $cc
    inc a                                         ; $229f: $3c
    jr z, jr_000_2280                             ; $22a0: $28 $de

    ld b, $0a                                     ; $22a2: $06 $0a

jr_000_22a4:
    call Call_000_20ab                            ; $22a4: $cd $ab $20
    call Call_000_22bf                            ; $22a7: $cd $bf $22
    dec b                                         ; $22aa: $05
    jr nz, jr_000_22a4                            ; $22ab: $20 $f7

    ld b, $0a                                     ; $22ad: $06 $0a

Jump_000_22af:
jr_000_22af:
    call Call_000_20ab                            ; $22af: $cd $ab $20

Call_000_22b2:
    call Call_000_22e9                            ; $22b2: $cd $e9 $22
    dec b                                         ; $22b5: $05
    jr nz, jr_000_22af                            ; $22b6: $20 $f7

    ld a, [$cc3e]                                 ; $22b8: $fa $3e $cc
    ld [$cc3d], a                                 ; $22bb: $ea $3d $cc
    ret                                           ; $22be: $c9


Call_000_22bf:
    call Call_000_22d3                            ; $22bf: $cd $d3 $22
    ld a, [$cc42]                                 ; $22c2: $fa $42 $cc
    add $60                                       ; $22c5: $c6 $60
    ldh [$ac], a                                  ; $22c7: $e0 $ac
    ldh a, [$aa]                                  ; $22c9: $f0 $aa
    cp $02                                        ; $22cb: $fe $02
    jr nz, jr_000_22d3                            ; $22cd: $20 $04

    ld a, $81                                     ; $22cf: $3e $81
    ldh [rSC], a                                  ; $22d1: $e0 $02

Call_000_22d3:
jr_000_22d3:
    ldh a, [$ad]                                  ; $22d3: $f0 $ad
    ld [$cc3d], a                                 ; $22d5: $ea $3d $cc
    and $f0                                       ; $22d8: $e6 $f0
    cp $60                                        ; $22da: $fe $60
    ret nz                                        ; $22dc: $c0

    xor a                                         ; $22dd: $af
    ldh [$ad], a                                  ; $22de: $e0 $ad
    ld a, [$cc3d]                                 ; $22e0: $fa $3d $cc
    and $0f                                       ; $22e3: $e6 $0f
    ld [$cc3e], a                                 ; $22e5: $ea $3e $cc
    ret                                           ; $22e8: $c9


Call_000_22e9:
    xor a                                         ; $22e9: $af
    ldh [$ac], a                                  ; $22ea: $e0 $ac
    ldh a, [$aa]                                  ; $22ec: $f0 $aa
    cp $02                                        ; $22ee: $fe $02
    ret nz                                        ; $22f0: $c0

    ld a, $81                                     ; $22f1: $3e $81
    ldh [rSC], a                                  ; $22f3: $e0 $02
    ret                                           ; $22f5: $c9


Call_000_22f6:
    ld a, $02                                     ; $22f6: $3e $02
    ldh [rSB], a                                  ; $22f8: $e0 $01
    xor a                                         ; $22fa: $af
    ldh [$ad], a                                  ; $22fb: $e0 $ad
    ld a, $80                                     ; $22fd: $3e $80

Call_000_22ff:
    ldh [rSC], a                                  ; $22ff: $e0 $02

Jump_000_2301:
    ret                                           ; $2301: $c9


Jump_000_2302:
    reti                                          ; $2302: $d9


Call_000_2303:
Jump_000_2303:
    call Call_000_3765                            ; $2303: $cd $65 $37
    xor a                                         ; $2306: $af
    ld c, a                                       ; $2307: $4f
    ld d, a                                       ; $2308: $57
    ld [$cfcf], a                                 ; $2309: $ea $cf $cf
    jr jr_000_2320                                ; $230c: $18 $12

Call_000_230e:
    ld c, $0a                                     ; $230e: $0e $0a
    ld d, $00                                     ; $2310: $16 $00
    ld a, [$d733]                                 ; $2312: $fa $33 $d7
    bit 5, a                                      ; $2315: $cb $6f
    jr z, jr_000_2320                             ; $2317: $28 $07

    xor a                                         ; $2319: $af
    ld [$cfcf], a                                 ; $231a: $ea $cf $cf
    ld c, $08                                     ; $231d: $0e $08
    ld d, c                                       ; $231f: $51

jr_000_2320:
    ld a, [$d705]                                 ; $2320: $fa $05 $d7
    and a                                         ; $2323: $a7

Jump_000_2324:
    jr z, jr_000_233f                             ; $2324: $28 $19

    cp $02                                        ; $2326: $fe $02
    jr z, jr_000_232e                             ; $2328: $28 $04

    ld a, $d2                                     ; $232a: $3e $d2
    jr jr_000_2330                                ; $232c: $18 $02

jr_000_232e:
    ld a, $d6                                     ; $232e: $3e $d6

jr_000_2330:
    ld b, a                                       ; $2330: $47
    ld a, d                                       ; $2331: $7a
    and a                                         ; $2332: $a7

Jump_000_2333:
    ld a, $1f                                     ; $2333: $3e $1f
    jr nz, jr_000_233a                            ; $2335: $20 $03

    ld [$c0ef], a                                 ; $2337: $ea $ef $c0

jr_000_233a:
    ld [$c0f0], a                                 ; $233a: $ea $f0 $c0
    jr jr_000_2348                                ; $233d: $18 $09

jr_000_233f:
    ld a, [$d360]                                 ; $233f: $fa $60 $d3
    ld b, a                                       ; $2342: $47
    call Call_000_2381                            ; $2343: $cd $81 $23
    jr c, jr_000_234d                             ; $2346: $38 $05

jr_000_2348:
    ld a, [$cfcf]                                 ; $2348: $fa $cf $cf
    cp b                                          ; $234b: $b8
    ret z                                         ; $234c: $c8

jr_000_234d:
    ld a, c                                       ; $234d: $79
    ld [$cfcc], a                                 ; $234e: $ea $cc $cf
    ld a, b                                       ; $2351: $78
    ld [$cfcf], a                                 ; $2352: $ea $cf $cf
    ld [$c0ee], a                                 ; $2355: $ea $ee $c0
    jp Jump_000_23ad                              ; $2358: $c3 $ad $23


Call_000_235b:
Jump_000_235b:
    ld a, [$c0ef]                                 ; $235b: $fa $ef $c0

Call_000_235e:
    ld b, a                                       ; $235e: $47
    cp $02                                        ; $235f: $fe $02
    jr nz, jr_000_2368                            ; $2361: $20 $05

    ld hl, $5103                                  ; $2363: $21 $03 $51
    jr jr_000_2374                                ; $2366: $18 $0c

jr_000_2368:
    cp $08                                        ; $2368: $fe $08
    jr nz, jr_000_2371                            ; $236a: $20 $05

    ld hl, $587b                                  ; $236c: $21 $7b $58
    jr jr_000_2374                                ; $236f: $18 $03

jr_000_2371:
    ld hl, $5177                                  ; $2371: $21 $77 $51

jr_000_2374:
    ld c, $06                                     ; $2374: $0e $06

jr_000_2376:
    push bc                                       ; $2376: $c5
    push hl                                       ; $2377: $e5
    call Call_000_35f3                            ; $2378: $cd $f3 $35
    pop hl                                        ; $237b: $e1
    pop bc                                        ; $237c: $c1
    dec c                                         ; $237d: $0d
    jr nz, jr_000_2376                            ; $237e: $20 $f6

    ret                                           ; $2380: $c9


Call_000_2381:
    ld a, [$d361]                                 ; $2381: $fa $61 $d3
    ld e, a                                       ; $2384: $5f
    ld a, [$c0ef]                                 ; $2385: $fa $ef $c0

Call_000_2388:
    cp e                                          ; $2388: $bb
    jr nz, jr_000_2390                            ; $2389: $20 $05

    ld [$c0f0], a                                 ; $238b: $ea $f0 $c0
    and a                                         ; $238e: $a7
    ret                                           ; $238f: $c9


jr_000_2390:
    ld a, c                                       ; $2390: $79
    and a                                         ; $2391: $a7
    ld a, e                                       ; $2392: $7b

Call_000_2393:
    jr nz, jr_000_2398                            ; $2393: $20 $03

    ld [$c0ef], a                                 ; $2395: $ea $ef $c0

jr_000_2398:
    ld [$c0f0], a                                 ; $2398: $ea $f0 $c0
    scf                                           ; $239b: $37
    ret                                           ; $239c: $c9


Call_000_239d:
Jump_000_239d:
    ld b, a                                       ; $239d: $47
    ld [$c0ee], a                                 ; $239e: $ea $ee $c0

Call_000_23a1:
    xor a                                         ; $23a1: $af
    ld [$cfcc], a                                 ; $23a2: $ea $cc $cf
    ld a, c                                       ; $23a5: $79
    ld [$c0ef], a                                 ; $23a6: $ea $ef $c0
    ld [$c0f0], a                                 ; $23a9: $ea $f0 $c0
    ld a, b                                       ; $23ac: $78

Call_000_23ad:
Jump_000_23ad:
    push hl                                       ; $23ad: $e5
    push de                                       ; $23ae: $d5
    push bc                                       ; $23af: $c5

Call_000_23b0:
    ld b, a                                       ; $23b0: $47
    ld a, [$c0ee]                                 ; $23b1: $fa $ee $c0
    and a                                         ; $23b4: $a7

Call_000_23b5:
    jr z, jr_000_23c4                             ; $23b5: $28 $0d

Call_000_23b7:
    xor a                                         ; $23b7: $af
    ld [$c02a], a                                 ; $23b8: $ea $2a $c0
    ld [$c02b], a                                 ; $23bb: $ea $2b $c0
    ld [$c02c], a                                 ; $23be: $ea $2c $c0

Call_000_23c1:
    ld [$c02d], a                                 ; $23c1: $ea $2d $c0

jr_000_23c4:
    ld a, [$cfcc]                                 ; $23c4: $fa $cc $cf

Call_000_23c7:
    and a                                         ; $23c7: $a7
    jr z, jr_000_23df                             ; $23c8: $28 $15

    ld a, [$c0ee]                                 ; $23ca: $fa $ee $c0
    and a                                         ; $23cd: $a7
    jr z, jr_000_2421                             ; $23ce: $28 $51

    xor a                                         ; $23d0: $af
    ld [$c0ee], a                                 ; $23d1: $ea $ee $c0
    ld a, [$cfcf]                                 ; $23d4: $fa $cf $cf
    cp $ff                                        ; $23d7: $fe $ff
    jr nz, jr_000_2410                            ; $23d9: $20 $35

    xor a                                         ; $23db: $af
    ld [$cfcc], a                                 ; $23dc: $ea $cc $cf

jr_000_23df:
    xor a                                         ; $23df: $af
    ld [$c0ee], a                                 ; $23e0: $ea $ee $c0

Jump_000_23e3:
    ldh a, [$b8]                                  ; $23e3: $f0 $b8

Jump_000_23e5:
    ldh [$b9], a                                  ; $23e5: $e0 $b9
    ld a, [$c0ef]                                 ; $23e7: $fa $ef $c0
    ldh [$b8], a                                  ; $23ea: $e0 $b8
    ld [$2000], a                                 ; $23ec: $ea $00 $20
    cp $02                                        ; $23ef: $fe $02
    jr nz, jr_000_23f9                            ; $23f1: $20 $06

    ld a, b                                       ; $23f3: $78
    call $5876                                    ; $23f4: $cd $76 $58
    jr jr_000_2407                                ; $23f7: $18 $0e

Jump_000_23f9:
jr_000_23f9:
    cp $08                                        ; $23f9: $fe $08
    jr nz, jr_000_2403                            ; $23fb: $20 $06

    ld a, b                                       ; $23fd: $78
    call $6039                                    ; $23fe: $cd $39 $60

Call_000_2401:
    jr jr_000_2407                                ; $2401: $18 $04

jr_000_2403:
    ld a, b                                       ; $2403: $78

Jump_000_2404:
    call $58ea                                    ; $2404: $cd $ea $58

jr_000_2407:
    ldh a, [$b9]                                  ; $2407: $f0 $b9
    ldh [$b8], a                                  ; $2409: $e0 $b8
    ld [$2000], a                                 ; $240b: $ea $00 $20
    jr jr_000_2421                                ; $240e: $18 $11

jr_000_2410:
    ld a, b                                       ; $2410: $78
    ld [$cfcf], a                                 ; $2411: $ea $cf $cf
    ld a, [$cfcc]                                 ; $2414: $fa $cc $cf
    ld [$cfcd], a                                 ; $2417: $ea $cd $cf
    ld [$cfce], a                                 ; $241a: $ea $ce $cf
    ld a, b                                       ; $241d: $78
    ld [$cfcc], a                                 ; $241e: $ea $cc $cf

jr_000_2421:
    pop bc                                        ; $2421: $c1
    pop de                                        ; $2422: $d1
    pop hl                                        ; $2423: $e1
    ret                                           ; $2424: $c9


Call_000_2425:
Jump_000_2425:
    ld a, [$cfd0]                                 ; $2425: $fa $d0 $cf

Call_000_2428:
    dec a                                         ; $2428: $3d
    ret nz                                        ; $2429: $c0

    ldh a, [$b8]                                  ; $242a: $f0 $b8

Jump_000_242c:
    push af                                       ; $242c: $f5
    ld a, $01                                     ; $242d: $3e $01
    ldh [$b8], a                                  ; $242f: $e0 $b8
    ld [$2000], a                                 ; $2431: $ea $00 $20
    call $4cb0                                    ; $2434: $cd $b0 $4c
    pop af                                        ; $2437: $f1
    ldh [$b8], a                                  ; $2438: $e0 $b8
    ld [$2000], a                                 ; $243a: $ea $00 $20
    ret                                           ; $243d: $c9


    cp $04                                        ; $243e: $fe $04
    inc b                                         ; $2440: $04
    dec bc                                        ; $2441: $0b
    rrca                                          ; $2442: $0f

Call_000_2443:
    inc c                                         ; $2443: $0c

Jump_000_2444:
    rst $38                                       ; $2444: $ff
    cp $07                                        ; $2445: $fe $07
    inc b                                         ; $2447: $04
    inc d                                         ; $2448: $14

Jump_000_2449:
    dec e                                         ; $2449: $1d
    dec bc                                        ; $244a: $0b
    inc c                                         ; $244b: $0c
    ld c, $0f                                     ; $244c: $0e $0f
    rst $38                                       ; $244e: $ff
    cp $07                                        ; $244f: $fe $07
    inc b                                         ; $2451: $04

Jump_000_2452:
    inc d                                         ; $2452: $14
    ld e, $0b                                     ; $2453: $1e $0b
    inc c                                         ; $2455: $0c
    ld c, $0f                                     ; $2456: $0e $0f

Call_000_2458:
    rst $38                                       ; $2458: $ff
    cp $01                                        ; $2459: $fe $01
    ld b, $ff                                     ; $245b: $06 $ff
    cp $06                                        ; $245d: $fe $06
    inc b                                         ; $245f: $04

Jump_000_2460:
    inc de                                        ; $2460: $13

Call_000_2461:
    dec c                                         ; $2461: $0d

Jump_000_2462:
    ld c, $0f                                     ; $2462: $0e $0f
    ld e, $ff                                     ; $2464: $1e $ff
    cp $09                                        ; $2466: $fe $09
    inc bc                                        ; $2468: $03
    inc de                                        ; $2469: $13
    dec [hl]                                      ; $246a: $35
    dec e                                         ; $246b: $1d
    jr c, jr_000_2479                             ; $246c: $38 $0b

    inc c                                         ; $246e: $0c
    dec c                                         ; $246f: $0d
    rrca                                          ; $2470: $0f
    rst $38                                       ; $2471: $ff
    cp $09                                        ; $2472: $fe $09

Call_000_2474:
    inc bc                                        ; $2474: $03
    inc de                                        ; $2475: $13
    dec [hl]                                      ; $2476: $35
    jr c, @+$0d                                   ; $2477: $38 $0b

jr_000_2479:
    inc c                                         ; $2479: $0c
    dec c                                         ; $247a: $0d
    ld c, $0f                                     ; $247b: $0e $0f
    rst $38                                       ; $247d: $ff
    cp $09                                        ; $247e: $fe $09
    add sp, -$17                                  ; $2480: $e8 $e9
    jp z, $edcf                                   ; $2482: $ca $cf $ed

    ret                                           ; $2485: $c9


    call $d9d1                                    ; $2486: $cd $d1 $d9
    rst $38                                       ; $2489: $ff
    cp $05                                        ; $248a: $fe $05
    inc sp                                        ; $248c: $33
    jr nz, jr_000_24b0                            ; $248d: $20 $21

    ld [hl+], a                                   ; $248f: $22
    cpl                                           ; $2490: $2f
    rst $38                                       ; $2491: $ff
    cp $07                                        ; $2492: $fe $07
    ld l, $37                                     ; $2494: $2e $37
    ld a, [hl-]                                   ; $2496: $3a
    ld b, c                                       ; $2497: $41

Call_000_2498:
    ld b, d                                       ; $2498: $42
    ld b, e                                       ; $2499: $43

Call_000_249a:
    ld b, h                                       ; $249a: $44
    rst $38                                       ; $249b: $ff
    cp $05                                        ; $249c: $fe $05
    inc hl                                        ; $249e: $23
    inc h                                         ; $249f: $24
    dec h                                         ; $24a0: $25
    ld h, $27                                     ; $24a1: $26 $27
    rst $38                                       ; $24a3: $ff
    cp $06                                        ; $24a4: $fe $06
    ld [bc], a                                    ; $24a6: $02
    inc bc                                        ; $24a7: $03
    inc de                                        ; $24a8: $13
    dec [hl]                                      ; $24a9: $35
    inc [hl]                                      ; $24aa: $34
    jr c, @+$01                                   ; $24ab: $38 $ff

    cp $05                                        ; $24ad: $fe $05
    inc bc                                        ; $24af: $03

jr_000_24b0:
    ld [de], a                                    ; $24b0: $12
    inc de                                        ; $24b1: $13
    inc [hl]                                      ; $24b2: $34
    dec [hl]                                      ; $24b3: $35
    rst $38                                       ; $24b4: $ff
    cp $07                                        ; $24b5: $fe $07
    ld [bc], a                                    ; $24b7: $02
    inc bc                                        ; $24b8: $03
    ld [de], a                                    ; $24b9: $12
    add hl, sp                                    ; $24ba: $39
    dec e                                         ; $24bb: $1d
    inc [hl]                                      ; $24bc: $34
    dec [hl]                                      ; $24bd: $35
    rst $38                                       ; $24be: $ff
    cp $06                                        ; $24bf: $fe $06
    inc bc                                        ; $24c1: $03

Jump_000_24c2:
    ld [de], a                                    ; $24c2: $12
    add hl, sp                                    ; $24c3: $39
    dec e                                         ; $24c4: $1d
    inc [hl]                                      ; $24c5: $34
    dec [hl]                                      ; $24c6: $35
    rst $38                                       ; $24c7: $ff
    cp $07                                        ; $24c8: $fe $07
    ld [bc], a                                    ; $24ca: $02
    inc bc                                        ; $24cb: $03
    db $10                                        ; $24cc: $10
    ld de, $3534                                  ; $24cd: $11 $34 $35
    add hl, sp                                    ; $24d0: $39
    rst $38                                       ; $24d1: $ff
    ld d, b                                       ; $24d2: $50

Jump_000_24d3:
    ld hl, $24d2                                  ; $24d3: $21 $d2 $24
    ret                                           ; $24d6: $c9


    rla                                           ; $24d7: $17
    sbc e                                         ; $24d8: $9b
    ld b, b                                       ; $24d9: $40
    jr nz, jr_000_252c                            ; $24da: $20 $50

    rla                                           ; $24dc: $17
    sbc [hl]                                      ; $24dd: $9e
    ld b, b                                       ; $24de: $40
    jr nz, @+$52                                  ; $24df: $20 $50

    rla                                           ; $24e1: $17
    cp [hl]                                       ; $24e2: $be
    ld b, b                                       ; $24e3: $40
    jr nz, @+$52                                  ; $24e4: $20 $50

    rla                                           ; $24e6: $17
    sbc $40                                       ; $24e7: $de $40
    jr nz, jr_000_253b                            ; $24e9: $20 $50

    rla                                           ; $24eb: $17
    ld b, $41                                     ; $24ec: $06 $41
    jr nz, @+$52                                  ; $24ee: $20 $50

    ld [$5c3e], sp                                ; $24f0: $08 $3e $5c
    call Call_000_3e8a                            ; $24f3: $cd $8a $3e
    jp Jump_000_24d3                              ; $24f6: $c3 $d3 $24


Jump_000_24f9:
    ld b, a                                       ; $24f9: $47
    ldh a, [$b8]                                  ; $24fa: $f0 $b8
    push af                                       ; $24fc: $f5
    ld a, b                                       ; $24fd: $78
    ldh [$b8], a                                  ; $24fe: $e0 $b8
    ld [$2000], a                                 ; $2500: $ea $00 $20
    ld a, $0a                                     ; $2503: $3e $0a

Jump_000_2505:
    ld [$0000], a                                 ; $2505: $ea $00 $00
    xor a                                         ; $2508: $af
    ld [$4000], a                                 ; $2509: $ea $00 $40
    call Call_000_2516                            ; $250c: $cd $16 $25
    pop af                                        ; $250f: $f1
    ldh [$b8], a                                  ; $2510: $e0 $b8
    ld [$2000], a                                 ; $2512: $ea $00 $20
    ret                                           ; $2515: $c9


Call_000_2516:
    ld hl, $a188                                  ; $2516: $21 $88 $a1
    ld c, $10                                     ; $2519: $0e $10
    ld b, $03                                     ; $251b: $06 $03
    xor a                                         ; $251d: $af
    call Call_000_36fd                            ; $251e: $cd $fd $36
    ld a, $01                                     ; $2521: $3e $01
    ld [$d0ab], a                                 ; $2523: $ea $ab $d0
    ld a, $03                                     ; $2526: $3e $03
    ld [$d0ac], a                                 ; $2528: $ea $ac $d0
    xor a                                         ; $252b: $af

Jump_000_252c:
jr_000_252c:
    ld [$d0a6], a                                 ; $252c: $ea $a6 $d0
    ld [$d0a7], a                                 ; $252f: $ea $a7 $d0
    ld [$d0ad], a                                 ; $2532: $ea $ad $d0
    call Call_000_2687                            ; $2535: $cd $87 $26
    ld b, a                                       ; $2538: $47
    and $0f                                       ; $2539: $e6 $0f

jr_000_253b:
    add a                                         ; $253b: $87

Jump_000_253c:
    add a                                         ; $253c: $87
    add a                                         ; $253d: $87
    ld [$d0a9], a                                 ; $253e: $ea $a9 $d0
    ld a, b                                       ; $2541: $78
    swap a                                        ; $2542: $cb $37
    and $0f                                       ; $2544: $e6 $0f
    add a                                         ; $2546: $87

Call_000_2547:
    add a                                         ; $2547: $87

Jump_000_2548:
    add a                                         ; $2548: $87
    ld [$d0a8], a                                 ; $2549: $ea $a8 $d0

Jump_000_254c:
    call Call_000_266c                            ; $254c: $cd $6c $26
    ld [$d0ad], a                                 ; $254f: $ea $ad $d0

Jump_000_2552:
    ld hl, $a188                                  ; $2552: $21 $88 $a1
    ld a, [$d0ad]                                 ; $2555: $fa $ad $d0
    bit 0, a                                      ; $2558: $cb $47
    jr z, jr_000_255f                             ; $255a: $28 $03

    ld hl, $a310                                  ; $255c: $21 $10 $a3

jr_000_255f:
    call Call_000_2893                            ; $255f: $cd $93 $28
    ld a, [$d0ad]                                 ; $2562: $fa $ad $d0
    bit 1, a                                      ; $2565: $cb $4f
    jr z, jr_000_2576                             ; $2567: $28 $0d

Call_000_2569:
    call Call_000_266c                            ; $2569: $cd $6c $26
    and a                                         ; $256c: $a7
    jr z, jr_000_2573                             ; $256d: $28 $04

    call Call_000_266c                            ; $256f: $cd $6c $26
    inc a                                         ; $2572: $3c

jr_000_2573:
    ld [$d0ae], a                                 ; $2573: $ea $ae $d0

jr_000_2576:
    call Call_000_266c                            ; $2576: $cd $6c $26
    and a                                         ; $2579: $a7
    jr z, jr_000_2591                             ; $257a: $28 $15

jr_000_257c:
    call Call_000_266c                            ; $257c: $cd $6c $26
    ld c, a                                       ; $257f: $4f
    call Call_000_266c                            ; $2580: $cd $6c $26
    sla c                                         ; $2583: $cb $21

Call_000_2585:
    or c                                          ; $2585: $b1
    and a                                         ; $2586: $a7
    jr z, jr_000_2591                             ; $2587: $28 $08

    call Call_000_2645                            ; $2589: $cd $45 $26
    call Call_000_25d4                            ; $258c: $cd $d4 $25
    jr jr_000_257c                                ; $258f: $18 $eb

jr_000_2591:
    ld c, $00                                     ; $2591: $0e $00

Call_000_2593:
jr_000_2593:
    call Call_000_266c                            ; $2593: $cd $6c $26
    and a                                         ; $2596: $a7

Call_000_2597:
    jr z, jr_000_259c                             ; $2597: $28 $03

    inc c                                         ; $2599: $0c
    jr jr_000_2593                                ; $259a: $18 $f7

jr_000_259c:
    ld a, c                                       ; $259c: $79
    add a                                         ; $259d: $87
    ld hl, $269b                                  ; $259e: $21 $9b $26
    add l                                         ; $25a1: $85
    ld l, a                                       ; $25a2: $6f
    jr nc, jr_000_25a6                            ; $25a3: $30 $01

    inc h                                         ; $25a5: $24

jr_000_25a6:
    ld a, [hl+]                                   ; $25a6: $2a
    ld e, a                                       ; $25a7: $5f
    ld d, [hl]                                    ; $25a8: $56
    push de                                       ; $25a9: $d5
    inc c                                         ; $25aa: $0c
    ld e, $00                                     ; $25ab: $1e $00
    ld d, e                                       ; $25ad: $53

jr_000_25ae:
    call Call_000_266c                            ; $25ae: $cd $6c $26
    or e                                          ; $25b1: $b3
    ld e, a                                       ; $25b2: $5f
    dec c                                         ; $25b3: $0d
    jr z, jr_000_25bc                             ; $25b4: $28 $06

    sla e                                         ; $25b6: $cb $23
    rl d                                          ; $25b8: $cb $12
    jr jr_000_25ae                                ; $25ba: $18 $f2

jr_000_25bc:
    pop hl                                        ; $25bc: $e1
    add hl, de                                    ; $25bd: $19
    ld e, l                                       ; $25be: $5d
    ld d, h                                       ; $25bf: $54

jr_000_25c0:
    ld b, e                                       ; $25c0: $43

Call_000_25c1:
    xor a                                         ; $25c1: $af
    call Call_000_2645                            ; $25c2: $cd $45 $26
    ld e, b                                       ; $25c5: $58
    call Call_000_25d4                            ; $25c6: $cd $d4 $25
    dec de                                        ; $25c9: $1b
    ld a, d                                       ; $25ca: $7a
    and a                                         ; $25cb: $a7
    jr nz, jr_000_25d0                            ; $25cc: $20 $02

    ld a, e                                       ; $25ce: $7b
    and a                                         ; $25cf: $a7

jr_000_25d0:
    jr nz, jr_000_25c0                            ; $25d0: $20 $ee

    jr jr_000_257c                                ; $25d2: $18 $a8

Call_000_25d4:
    ld a, [$d0a9]                                 ; $25d4: $fa $a9 $d0
    ld b, a                                       ; $25d7: $47
    ld a, [$d0a7]                                 ; $25d8: $fa $a7 $d0
    inc a                                         ; $25db: $3c
    cp b                                          ; $25dc: $b8
    jr z, jr_000_25f2                             ; $25dd: $28 $13

    ld [$d0a7], a                                 ; $25df: $ea $a7 $d0
    ld a, [$d0b2]                                 ; $25e2: $fa $b2 $d0

Jump_000_25e5:
    inc a                                         ; $25e5: $3c
    ld [$d0b2], a                                 ; $25e6: $ea $b2 $d0
    ret nz                                        ; $25e9: $c0

Call_000_25ea:
    ld a, [$d0b3]                                 ; $25ea: $fa $b3 $d0
    inc a                                         ; $25ed: $3c
    ld [$d0b3], a                                 ; $25ee: $ea $b3 $d0
    ret                                           ; $25f1: $c9


jr_000_25f2:
    xor a                                         ; $25f2: $af
    ld [$d0a7], a                                 ; $25f3: $ea $a7 $d0
    ld a, [$d0ac]                                 ; $25f6: $fa $ac $d0
    and a                                         ; $25f9: $a7
    jr z, jr_000_260c                             ; $25fa: $28 $10

    dec a                                         ; $25fc: $3d
    ld [$d0ac], a                                 ; $25fd: $ea $ac $d0
    ld hl, $d0b4                                  ; $2600: $21 $b4 $d0
    ld a, [hl+]                                   ; $2603: $2a
    ld [$d0b2], a                                 ; $2604: $ea $b2 $d0
    ld a, [hl]                                    ; $2607: $7e
    ld [$d0b3], a                                 ; $2608: $ea $b3 $d0
    ret                                           ; $260b: $c9


jr_000_260c:
    ld a, $03                                     ; $260c: $3e $03
    ld [$d0ac], a                                 ; $260e: $ea $ac $d0
    ld a, [$d0a6]                                 ; $2611: $fa $a6 $d0
    add $08                                       ; $2614: $c6 $08
    ld [$d0a6], a                                 ; $2616: $ea $a6 $d0
    ld b, a                                       ; $2619: $47

Jump_000_261a:
    ld a, [$d0a8]                                 ; $261a: $fa $a8 $d0
    cp b                                          ; $261d: $b8

Call_000_261e:
    jr z, jr_000_262c                             ; $261e: $28 $0c

    ld a, [$d0b2]                                 ; $2620: $fa $b2 $d0
    ld l, a                                       ; $2623: $6f
    ld a, [$d0b3]                                 ; $2624: $fa $b3 $d0
    ld h, a                                       ; $2627: $67
    inc hl                                        ; $2628: $23
    jp Jump_000_2893                              ; $2629: $c3 $93 $28


Call_000_262c:
jr_000_262c:
    pop hl                                        ; $262c: $e1
    xor a                                         ; $262d: $af
    ld [$d0a6], a                                 ; $262e: $ea $a6 $d0
    ld a, [$d0ad]                                 ; $2631: $fa $ad $d0
    bit 1, a                                      ; $2634: $cb $4f
    jr nz, jr_000_2642                            ; $2636: $20 $0a

    xor $01                                       ; $2638: $ee $01
    set 1, a                                      ; $263a: $cb $cf
    ld [$d0ad], a                                 ; $263c: $ea $ad $d0
    jp Jump_000_2552                              ; $263f: $c3 $52 $25


jr_000_2642:
    jp Jump_000_26bb                              ; $2642: $c3 $bb $26


Call_000_2645:
    ld e, a                                       ; $2645: $5f

Call_000_2646:
    ld a, [$d0ac]                                 ; $2646: $fa $ac $d0

Call_000_2649:
    and a                                         ; $2649: $a7
    jr z, jr_000_2660                             ; $264a: $28 $14

Jump_000_264c:
    cp $02                                        ; $264c: $fe $02

Call_000_264e:
    jr c, jr_000_2658                             ; $264e: $38 $08

    jr z, jr_000_265e                             ; $2650: $28 $0c

    rrc e                                         ; $2652: $cb $0b
    rrc e                                         ; $2654: $cb $0b
    jr jr_000_2660                                ; $2656: $18 $08

jr_000_2658:
    sla e                                         ; $2658: $cb $23

Call_000_265a:
    sla e                                         ; $265a: $cb $23
    jr jr_000_2660                                ; $265c: $18 $02

jr_000_265e:
    swap e                                        ; $265e: $cb $33

jr_000_2660:
    ld a, [$d0b2]                                 ; $2660: $fa $b2 $d0
    ld l, a                                       ; $2663: $6f
    ld a, [$d0b3]                                 ; $2664: $fa $b3 $d0
    ld h, a                                       ; $2667: $67
    ld a, [hl]                                    ; $2668: $7e
    or e                                          ; $2669: $b3
    ld [hl], a                                    ; $266a: $77
    ret                                           ; $266b: $c9


Call_000_266c:
    ld a, [$d0ab]                                 ; $266c: $fa $ab $d0
    dec a                                         ; $266f: $3d
    jr nz, jr_000_267a                            ; $2670: $20 $08

    call Call_000_2687                            ; $2672: $cd $87 $26
    ld [$d0aa], a                                 ; $2675: $ea $aa $d0
    ld a, $08                                     ; $2678: $3e $08

jr_000_267a:
    ld [$d0ab], a                                 ; $267a: $ea $ab $d0
    ld a, [$d0aa]                                 ; $267d: $fa $aa $d0
    rlca                                          ; $2680: $07
    ld [$d0aa], a                                 ; $2681: $ea $aa $d0
    and $01                                       ; $2684: $e6 $01
    ret                                           ; $2686: $c9


Call_000_2687:
    ld a, [$d0b0]                                 ; $2687: $fa $b0 $d0
    ld l, a                                       ; $268a: $6f
    ld a, [$d0b1]                                 ; $268b: $fa $b1 $d0
    ld h, a                                       ; $268e: $67
    ld a, [hl+]                                   ; $268f: $2a
    ld b, a                                       ; $2690: $47
    ld a, l                                       ; $2691: $7d
    ld [$d0b0], a                                 ; $2692: $ea $b0 $d0
    ld a, h                                       ; $2695: $7c
    ld [$d0b1], a                                 ; $2696: $ea $b1 $d0
    ld a, b                                       ; $2699: $78
    ret                                           ; $269a: $c9


    ld bc, $0300                                  ; $269b: $01 $00 $03
    nop                                           ; $269e: $00
    rlca                                          ; $269f: $07
    nop                                           ; $26a0: $00
    rrca                                          ; $26a1: $0f
    nop                                           ; $26a2: $00
    rra                                           ; $26a3: $1f
    nop                                           ; $26a4: $00

Jump_000_26a5:
    ccf                                           ; $26a5: $3f
    nop                                           ; $26a6: $00
    ld a, a                                       ; $26a7: $7f

Call_000_26a8:
    nop                                           ; $26a8: $00
    rst $38                                       ; $26a9: $ff
    nop                                           ; $26aa: $00
    rst $38                                       ; $26ab: $ff
    ld bc, $03ff                                  ; $26ac: $01 $ff $03
    rst $38                                       ; $26af: $ff
    rlca                                          ; $26b0: $07
    rst $38                                       ; $26b1: $ff
    rrca                                          ; $26b2: $0f
    rst $38                                       ; $26b3: $ff
    rra                                           ; $26b4: $1f
    rst $38                                       ; $26b5: $ff
    ccf                                           ; $26b6: $3f
    rst $38                                       ; $26b7: $ff
    ld a, a                                       ; $26b8: $7f
    rst $38                                       ; $26b9: $ff
    rst $38                                       ; $26ba: $ff

Jump_000_26bb:
    ld a, [$d0ae]                                 ; $26bb: $fa $ae $d0
    cp $02                                        ; $26be: $fe $02
    jp z, Jump_000_2873                           ; $26c0: $ca $73 $28

    and a                                         ; $26c3: $a7
    jp nz, Jump_000_27c3                          ; $26c4: $c2 $c3 $27

    ld hl, $a188                                  ; $26c7: $21 $88 $a1
    call Call_000_26d0                            ; $26ca: $cd $d0 $26
    ld hl, $a310                                  ; $26cd: $21 $10 $a3

Call_000_26d0:
    xor a                                         ; $26d0: $af
    ld [$d0a6], a                                 ; $26d1: $ea $a6 $d0
    ld [$d0a7], a                                 ; $26d4: $ea $a7 $d0
    call Call_000_2893                            ; $26d7: $cd $93 $28
    ld a, [$d0af]                                 ; $26da: $fa $af $d0
    and a                                         ; $26dd: $a7
    jr z, jr_000_26e8                             ; $26de: $28 $08

    ld hl, $27b3                                  ; $26e0: $21 $b3 $27
    ld de, $27bb                                  ; $26e3: $11 $bb $27
    jr jr_000_26ee                                ; $26e6: $18 $06

jr_000_26e8:
    ld hl, $27a3                                  ; $26e8: $21 $a3 $27
    ld de, $27ab                                  ; $26eb: $11 $ab $27

jr_000_26ee:
    ld a, l                                       ; $26ee: $7d
    ld [$d0b6], a                                 ; $26ef: $ea $b6 $d0
    ld a, h                                       ; $26f2: $7c
    ld [$d0b7], a                                 ; $26f3: $ea $b7 $d0
    ld a, e                                       ; $26f6: $7b
    ld [$d0b8], a                                 ; $26f7: $ea $b8 $d0
    ld a, d                                       ; $26fa: $7a
    ld [$d0b9], a                                 ; $26fb: $ea $b9 $d0
    ld e, $00                                     ; $26fe: $1e $00

jr_000_2700:
    ld a, [$d0b2]                                 ; $2700: $fa $b2 $d0
    ld l, a                                       ; $2703: $6f

Jump_000_2704:
    ld a, [$d0b3]                                 ; $2704: $fa $b3 $d0
    ld h, a                                       ; $2707: $67
    ld a, [hl]                                    ; $2708: $7e
    ld b, a                                       ; $2709: $47
    swap a                                        ; $270a: $cb $37
    and $0f                                       ; $270c: $e6 $0f
    call Call_000_2769                            ; $270e: $cd $69 $27
    swap a                                        ; $2711: $cb $37
    ld d, a                                       ; $2713: $57
    ld a, b                                       ; $2714: $78
    and $0f                                       ; $2715: $e6 $0f
    call Call_000_2769                            ; $2717: $cd $69 $27
    or d                                          ; $271a: $b2
    ld b, a                                       ; $271b: $47
    ld a, [$d0b2]                                 ; $271c: $fa $b2 $d0
    ld l, a                                       ; $271f: $6f
    ld a, [$d0b3]                                 ; $2720: $fa $b3 $d0
    ld h, a                                       ; $2723: $67
    ld a, b                                       ; $2724: $78
    ld [hl], a                                    ; $2725: $77
    ld a, [$d0a9]                                 ; $2726: $fa $a9 $d0
    add l                                         ; $2729: $85
    jr nc, jr_000_272d                            ; $272a: $30 $01

    inc h                                         ; $272c: $24

jr_000_272d:
    ld [$d0b2], a                                 ; $272d: $ea $b2 $d0
    ld a, h                                       ; $2730: $7c
    ld [$d0b3], a                                 ; $2731: $ea $b3 $d0
    ld a, [$d0a6]                                 ; $2734: $fa $a6 $d0
    add $08                                       ; $2737: $c6 $08
    ld [$d0a6], a                                 ; $2739: $ea $a6 $d0
    ld b, a                                       ; $273c: $47
    ld a, [$d0a8]                                 ; $273d: $fa $a8 $d0

Jump_000_2740:
    cp b                                          ; $2740: $b8
    jr nz, jr_000_2700                            ; $2741: $20 $bd

    xor a                                         ; $2743: $af

Call_000_2744:
    ld e, a                                       ; $2744: $5f
    ld [$d0a6], a                                 ; $2745: $ea $a6 $d0

Call_000_2748:
    ld a, [$d0a7]                                 ; $2748: $fa $a7 $d0
    inc a                                         ; $274b: $3c

Call_000_274c:
    ld [$d0a7], a                                 ; $274c: $ea $a7 $d0
    ld b, a                                       ; $274f: $47
    ld a, [$d0a9]                                 ; $2750: $fa $a9 $d0
    cp b                                          ; $2753: $b8
    jr z, jr_000_2764                             ; $2754: $28 $0e

    ld a, [$d0b4]                                 ; $2756: $fa $b4 $d0
    ld l, a                                       ; $2759: $6f

Jump_000_275a:
    ld a, [$d0b5]                                 ; $275a: $fa $b5 $d0

Call_000_275d:
    ld h, a                                       ; $275d: $67
    inc hl                                        ; $275e: $23
    call Call_000_2893                            ; $275f: $cd $93 $28
    jr jr_000_2700                                ; $2762: $18 $9c

jr_000_2764:
    xor a                                         ; $2764: $af
    ld [$d0a7], a                                 ; $2765: $ea $a7 $d0

Jump_000_2768:
    ret                                           ; $2768: $c9


Call_000_2769:
    srl a                                         ; $2769: $cb $3f
    ld c, $00                                     ; $276b: $0e $00
    jr nc, jr_000_2771                            ; $276d: $30 $02

    ld c, $01                                     ; $276f: $0e $01

jr_000_2771:
    ld l, a                                       ; $2771: $6f
    ld a, [$d0af]                                 ; $2772: $fa $af $d0
    and a                                         ; $2775: $a7
    jr z, jr_000_277c                             ; $2776: $28 $04

    bit 3, e                                      ; $2778: $cb $5b
    jr jr_000_277e                                ; $277a: $18 $02

jr_000_277c:
    bit 0, e                                      ; $277c: $cb $43

jr_000_277e:
    ld e, l                                       ; $277e: $5d
    jr nz, jr_000_278a                            ; $277f: $20 $09

    ld a, [$d0b6]                                 ; $2781: $fa $b6 $d0
    ld l, a                                       ; $2784: $6f
    ld a, [$d0b7]                                 ; $2785: $fa $b7 $d0
    jr jr_000_2791                                ; $2788: $18 $07

jr_000_278a:
    ld a, [$d0b8]                                 ; $278a: $fa $b8 $d0
    ld l, a                                       ; $278d: $6f
    ld a, [$d0b9]                                 ; $278e: $fa $b9 $d0

jr_000_2791:
    ld h, a                                       ; $2791: $67
    ld a, e                                       ; $2792: $7b
    add l                                         ; $2793: $85
    ld l, a                                       ; $2794: $6f
    jr nc, jr_000_2798                            ; $2795: $30 $01

Call_000_2797:
    inc h                                         ; $2797: $24

jr_000_2798:
    ld a, [hl]                                    ; $2798: $7e
    bit 0, c                                      ; $2799: $cb $41
    jr nz, jr_000_279f                            ; $279b: $20 $02

    swap a                                        ; $279d: $cb $37

jr_000_279f:
    and $0f                                       ; $279f: $e6 $0f
    ld e, a                                       ; $27a1: $5f
    ret                                           ; $27a2: $c9


    ld bc, $7632                                  ; $27a3: $01 $32 $76
    ld b, l                                       ; $27a6: $45
    cp $cd                                        ; $27a7: $fe $cd
    adc c                                         ; $27a9: $89
    cp d                                          ; $27aa: $ba
    cp $cd                                        ; $27ab: $fe $cd
    adc c                                         ; $27ad: $89
    cp d                                          ; $27ae: $ba
    ld bc, $7632                                  ; $27af: $01 $32 $76
    ld b, l                                       ; $27b2: $45
    ld [$e6c4], sp                                ; $27b3: $08 $c4 $e6
    ld a, [hl+]                                   ; $27b6: $2a

Call_000_27b7:
    rst $30                                       ; $27b7: $f7
    dec sp                                        ; $27b8: $3b
    add hl, de                                    ; $27b9: $19
    push de                                       ; $27ba: $d5

Jump_000_27bb:
    rst $30                                       ; $27bb: $f7
    dec sp                                        ; $27bc: $3b
    add hl, de                                    ; $27bd: $19
    push de                                       ; $27be: $d5
    ld [$e6c4], sp                                ; $27bf: $08 $c4 $e6
    ld a, [hl+]                                   ; $27c2: $2a

Jump_000_27c3:
    xor a                                         ; $27c3: $af

Jump_000_27c4:
    ld [$d0a6], a                                 ; $27c4: $ea $a6 $d0

Call_000_27c7:
    ld [$d0a7], a                                 ; $27c7: $ea $a7 $d0
    call Call_000_283d                            ; $27ca: $cd $3d $28
    ld a, [$d0b2]                                 ; $27cd: $fa $b2 $d0
    ld l, a                                       ; $27d0: $6f
    ld a, [$d0b3]                                 ; $27d1: $fa $b3 $d0
    ld h, a                                       ; $27d4: $67
    call Call_000_26d0                            ; $27d5: $cd $d0 $26
    call Call_000_283d                            ; $27d8: $cd $3d $28
    ld a, [$d0b2]                                 ; $27db: $fa $b2 $d0
    ld l, a                                       ; $27de: $6f
    ld a, [$d0b3]                                 ; $27df: $fa $b3 $d0
    ld h, a                                       ; $27e2: $67
    ld a, [$d0b4]                                 ; $27e3: $fa $b4 $d0
    ld e, a                                       ; $27e6: $5f

Call_000_27e7:
    ld a, [$d0b5]                                 ; $27e7: $fa $b5 $d0
    ld d, a                                       ; $27ea: $57

jr_000_27eb:
    ld a, [$d0af]                                 ; $27eb: $fa $af $d0
    and a                                         ; $27ee: $a7
    jr z, jr_000_2807                             ; $27ef: $28 $16

    push de                                       ; $27f1: $d5
    ld a, [de]                                    ; $27f2: $1a
    ld b, a                                       ; $27f3: $47
    swap a                                        ; $27f4: $cb $37
    and $0f                                       ; $27f6: $e6 $0f
    call Call_000_2833                            ; $27f8: $cd $33 $28
    swap a                                        ; $27fb: $cb $37
    ld c, a                                       ; $27fd: $4f
    ld a, b                                       ; $27fe: $78
    and $0f                                       ; $27ff: $e6 $0f
    call Call_000_2833                            ; $2801: $cd $33 $28
    or c                                          ; $2804: $b1
    pop de                                        ; $2805: $d1

Call_000_2806:
    ld [de], a                                    ; $2806: $12

Jump_000_2807:
jr_000_2807:
    ld a, [hl+]                                   ; $2807: $2a
    ld b, a                                       ; $2808: $47
    ld a, [de]                                    ; $2809: $1a
    xor b                                         ; $280a: $a8
    ld [de], a                                    ; $280b: $12

Jump_000_280c:
    inc de                                        ; $280c: $13
    ld a, [$d0a7]                                 ; $280d: $fa $a7 $d0
    inc a                                         ; $2810: $3c

Jump_000_2811:
    ld [$d0a7], a                                 ; $2811: $ea $a7 $d0
    ld b, a                                       ; $2814: $47
    ld a, [$d0a9]                                 ; $2815: $fa $a9 $d0
    cp b                                          ; $2818: $b8
    jr nz, jr_000_27eb                            ; $2819: $20 $d0

    xor a                                         ; $281b: $af
    ld [$d0a7], a                                 ; $281c: $ea $a7 $d0
    ld a, [$d0a6]                                 ; $281f: $fa $a6 $d0

Call_000_2822:
    add $08                                       ; $2822: $c6 $08
    ld [$d0a6], a                                 ; $2824: $ea $a6 $d0
    ld b, a                                       ; $2827: $47
    ld a, [$d0a8]                                 ; $2828: $fa $a8 $d0
    cp b                                          ; $282b: $b8
    jr nz, jr_000_27eb                            ; $282c: $20 $bd

    xor a                                         ; $282e: $af
    ld [$d0a6], a                                 ; $282f: $ea $a6 $d0
    ret                                           ; $2832: $c9


Call_000_2833:
Jump_000_2833:
    ld de, $2863                                  ; $2833: $11 $63 $28
    add e                                         ; $2836: $83
    ld e, a                                       ; $2837: $5f
    jr nc, jr_000_283b                            ; $2838: $30 $01

    inc d                                         ; $283a: $14

jr_000_283b:
    ld a, [de]                                    ; $283b: $1a
    ret                                           ; $283c: $c9


Call_000_283d:
Jump_000_283d:
    ld a, [$d0ad]                                 ; $283d: $fa $ad $d0
    bit 0, a                                      ; $2840: $cb $47
    jr nz, jr_000_284c                            ; $2842: $20 $08

    ld de, $a188                                  ; $2844: $11 $88 $a1
    ld hl, $a310                                  ; $2847: $21 $10 $a3

Jump_000_284a:
    jr jr_000_2852                                ; $284a: $18 $06

Jump_000_284c:
jr_000_284c:
    ld de, $a310                                  ; $284c: $11 $10 $a3
    ld hl, $a188                                  ; $284f: $21 $88 $a1

jr_000_2852:
    ld a, l                                       ; $2852: $7d
    ld [$d0b2], a                                 ; $2853: $ea $b2 $d0
    ld a, h                                       ; $2856: $7c
    ld [$d0b3], a                                 ; $2857: $ea $b3 $d0
    ld a, e                                       ; $285a: $7b

Call_000_285b:
    ld [$d0b4], a                                 ; $285b: $ea $b4 $d0
    ld a, d                                       ; $285e: $7a

Call_000_285f:
    ld [$d0b5], a                                 ; $285f: $ea $b5 $d0
    ret                                           ; $2862: $c9


    nop                                           ; $2863: $00
    ld [$0c04], sp                                ; $2864: $08 $04 $0c
    ld [bc], a                                    ; $2867: $02
    ld a, [bc]                                    ; $2868: $0a
    ld b, $0e                                     ; $2869: $06 $0e
    ld bc, $0509                                  ; $286b: $01 $09 $05
    dec c                                         ; $286e: $0d
    inc bc                                        ; $286f: $03
    dec bc                                        ; $2870: $0b
    rlca                                          ; $2871: $07
    rrca                                          ; $2872: $0f

Jump_000_2873:
    call Call_000_283d                            ; $2873: $cd $3d $28
    ld a, [$d0af]                                 ; $2876: $fa $af $d0
    push af                                       ; $2879: $f5
    xor a                                         ; $287a: $af
    ld [$d0af], a                                 ; $287b: $ea $af $d0
    ld a, [$d0b4]                                 ; $287e: $fa $b4 $d0
    ld l, a                                       ; $2881: $6f
    ld a, [$d0b5]                                 ; $2882: $fa $b5 $d0
    ld h, a                                       ; $2885: $67
    call Call_000_26d0                            ; $2886: $cd $d0 $26
    call Call_000_283d                            ; $2889: $cd $3d $28
    pop af                                        ; $288c: $f1

Call_000_288d:
    ld [$d0af], a                                 ; $288d: $ea $af $d0
    jp Jump_000_27c3                              ; $2890: $c3 $c3 $27


Call_000_2893:
Jump_000_2893:
    ld a, l                                       ; $2893: $7d
    ld [$d0b2], a                                 ; $2894: $ea $b2 $d0
    ld [$d0b4], a                                 ; $2897: $ea $b4 $d0
    ld a, h                                       ; $289a: $7c
    ld [$d0b3], a                                 ; $289b: $ea $b3 $d0
    ld [$d0b5], a                                 ; $289e: $ea $b5 $d0
    ret                                           ; $28a1: $c9


Call_000_28a2:
    ld hl, $c100                                  ; $28a2: $21 $00 $c1
    call Call_000_28c0                            ; $28a5: $cd $c0 $28

Call_000_28a8:
    ld hl, $c200                                  ; $28a8: $21 $00 $c2
    call Call_000_28c0                            ; $28ab: $cd $c0 $28
    ld a, $01                                     ; $28ae: $3e $01
    ld [$c100], a                                 ; $28b0: $ea $00 $c1
    ld [$c20e], a                                 ; $28b3: $ea $0e $c2
    ld hl, $c104                                  ; $28b6: $21 $04 $c1
    ld [hl], $3c                                  ; $28b9: $36 $3c
    inc hl                                        ; $28bb: $23

Call_000_28bc:
    inc hl                                        ; $28bc: $23
    ld [hl], $40                                  ; $28bd: $36 $40
    ret                                           ; $28bf: $c9


Call_000_28c0:
    ld bc, $0010                                  ; $28c0: $01 $10 $00
    xor a                                         ; $28c3: $af
    jp Jump_000_36fd                              ; $28c4: $c3 $fd $36


Call_000_28c7:
    ld a, [$cfcc]                                 ; $28c7: $fa $cc $cf
    and a                                         ; $28ca: $a7
    jr nz, jr_000_28d8                            ; $28cb: $20 $0b

    ld a, [$d731]                                 ; $28cd: $fa $31 $d7
    bit 1, a                                      ; $28d0: $cb $4f
    ret nz                                        ; $28d2: $c0

    ld a, $77                                     ; $28d3: $3e $77
    ldh [rNR50], a                                ; $28d5: $e0 $24
    ret                                           ; $28d7: $c9


jr_000_28d8:
    ld a, [$cfce]                                 ; $28d8: $fa $ce $cf
    and a                                         ; $28db: $a7
    jr z, jr_000_28e3                             ; $28dc: $28 $05

    dec a                                         ; $28de: $3d
    ld [$cfce], a                                 ; $28df: $ea $ce $cf
    ret                                           ; $28e2: $c9


jr_000_28e3:
    ld a, [$cfcd]                                 ; $28e3: $fa $cd $cf
    ld [$cfce], a                                 ; $28e6: $ea $ce $cf
    ldh a, [rNR50]                                ; $28e9: $f0 $24
    and a                                         ; $28eb: $a7
    jr z, jr_000_28ff                             ; $28ec: $28 $11

    ld b, a                                       ; $28ee: $47
    and $0f                                       ; $28ef: $e6 $0f
    dec a                                         ; $28f1: $3d
    ld c, a                                       ; $28f2: $4f

Jump_000_28f3:
    ld a, b                                       ; $28f3: $78
    and $f0                                       ; $28f4: $e6 $f0
    swap a                                        ; $28f6: $cb $37
    dec a                                         ; $28f8: $3d
    swap a                                        ; $28f9: $cb $37
    or c                                          ; $28fb: $b1
    ldh [rNR50], a                                ; $28fc: $e0 $24
    ret                                           ; $28fe: $c9


jr_000_28ff:
    ld a, [$cfcc]                                 ; $28ff: $fa $cc $cf
    ld b, a                                       ; $2902: $47
    xor a                                         ; $2903: $af

Call_000_2904:
    ld [$cfcc], a                                 ; $2904: $ea $cc $cf
    ld a, $ff                                     ; $2907: $3e $ff
    ld [$c0ee], a                                 ; $2909: $ea $ee $c0
    call Call_000_23ad                            ; $290c: $cd $ad $23
    ld a, [$c0f0]                                 ; $290f: $fa $f0 $c0
    ld [$c0ef], a                                 ; $2912: $ea $ef $c0
    ld a, b                                       ; $2915: $78

Jump_000_2916:
    ld [$c0ee], a                                 ; $2916: $ea $ee $c0
    jp Jump_000_23ad                              ; $2919: $c3 $ad $23


Call_000_291c:
Jump_000_291c:
    ldh a, [$b8]                                  ; $291c: $f0 $b8
    push af                                       ; $291e: $f5
    ld b, $01                                     ; $291f: $06 $01
    ld hl, $7129                                  ; $2921: $21 $29 $71
    call Call_000_35f3                            ; $2924: $cd $f3 $35
    ld hl, $cf16                                  ; $2927: $21 $16 $cf

Jump_000_292a:
    bit 0, [hl]                                   ; $292a: $cb $46
    res 0, [hl]                                   ; $292c: $cb $86
    jr nz, jr_000_2936                            ; $292e: $20 $06

    ld a, [$d363]                                 ; $2930: $fa $63 $d3
    call Call_000_12bc                            ; $2933: $cd $bc $12

jr_000_2936:
    ld a, $1e                                     ; $2936: $3e $1e
    ldh [$d5], a                                  ; $2938: $e0 $d5
    ld hl, $d371                                  ; $293a: $21 $71 $d3
    ld a, [hl+]                                   ; $293d: $2a
    ld h, [hl]                                    ; $293e: $66
    ld l, a                                       ; $293f: $6f
    ld d, $00                                     ; $2940: $16 $00
    ldh a, [$8c]                                  ; $2942: $f0 $8c
    ld [$cf18], a                                 ; $2944: $ea $18 $cf
    and a                                         ; $2947: $a7
    jp z, Jump_000_2ae3                           ; $2948: $ca $e3 $2a

    cp $d3                                        ; $294b: $fe $d3
    jp z, Jump_000_2a8c                           ; $294d: $ca $8c $2a

    cp $d0                                        ; $2950: $fe $d0
    jp z, Jump_000_2a97                           ; $2952: $ca $97 $2a

Call_000_2955:
    cp $d1                                        ; $2955: $fe $d1
    jp z, Jump_000_2aa5                           ; $2957: $ca $a5 $2a

    cp $d2                                        ; $295a: $fe $d2
    jp z, Jump_000_2ad5                           ; $295c: $ca $d5 $2a

    ld a, [$d4e6]                                 ; $295f: $fa $e6 $d4
    ld e, a                                       ; $2962: $5f
    ldh a, [$8c]                                  ; $2963: $f0 $8c

Call_000_2965:
    cp e                                          ; $2965: $bb
    jr z, jr_000_296a                             ; $2966: $28 $02

    jr nc, jr_000_2986                            ; $2968: $30 $1c

jr_000_296a:
    push hl                                       ; $296a: $e5
    push de                                       ; $296b: $d5
    push bc                                       ; $296c: $c5
    ld b, $04                                     ; $296d: $06 $04
    ld hl, $7082                                  ; $296f: $21 $82 $70
    call Call_000_35f3                            ; $2972: $cd $f3 $35
    pop bc                                        ; $2975: $c1
    pop de                                        ; $2976: $d1
    ld hl, $d4e9                                  ; $2977: $21 $e9 $d4
    ldh a, [$8c]                                  ; $297a: $f0 $8c
    dec a                                         ; $297c: $3d
    add a                                         ; $297d: $87
    add l                                         ; $297e: $85
    ld l, a                                       ; $297f: $6f
    jr nc, jr_000_2983                            ; $2980: $30 $01

Jump_000_2982:
    inc h                                         ; $2982: $24

jr_000_2983:
    inc hl                                        ; $2983: $23
    ld a, [hl]                                    ; $2984: $7e
    pop hl                                        ; $2985: $e1

jr_000_2986:
    dec a                                         ; $2986: $3d

Jump_000_2987:
    ld e, a                                       ; $2987: $5f
    sla e                                         ; $2988: $cb $23
    add hl, de                                    ; $298a: $19
    ld a, [hl+]                                   ; $298b: $2a
    ld h, [hl]                                    ; $298c: $66
    ld l, a                                       ; $298d: $6f
    ld a, [hl]                                    ; $298e: $7e
    cp $fe                                        ; $298f: $fe $fe
    jp z, Jump_000_2a2a                           ; $2991: $ca $2a $2a

    cp $ff                                        ; $2994: $fe $ff
    jp z, Jump_000_2a6e                           ; $2996: $ca $6e $2a

    cp $fc                                        ; $2999: $fe $fc
    jp z, Jump_000_347d                           ; $299b: $ca $7d $34

    cp $fd                                        ; $299e: $fe $fd
    jp z, Jump_000_3487                           ; $29a0: $ca $87 $34

    cp $f9                                        ; $29a3: $fe $f9
    jp z, Jump_000_349c                           ; $29a5: $ca $9c $34

Call_000_29a8:
    cp $f5                                        ; $29a8: $fe $f5
    jr nz, jr_000_29b6                            ; $29aa: $20 $0a

    ld b, $1d                                     ; $29ac: $06 $1d
    ld hl, $4f28                                  ; $29ae: $21 $28 $4f
    call Call_000_35f3                            ; $29b1: $cd $f3 $35

Call_000_29b4:
    jr jr_000_29d2                                ; $29b4: $18 $1c

jr_000_29b6:
    cp $f7                                        ; $29b6: $fe $f7
    jp z, Jump_000_3491                           ; $29b8: $ca $91 $34

    cp $f6                                        ; $29bb: $fe $f6
    jr nz, jr_000_29c9                            ; $29bd: $20 $0a

    ld hl, $7259                                  ; $29bf: $21 $59 $72
    ld b, $01                                     ; $29c2: $06 $01
    call Call_000_35f3                            ; $29c4: $cd $f3 $35

Call_000_29c7:
    jr jr_000_29d2                                ; $29c7: $18 $09

jr_000_29c9:
    call Call_000_3c76                            ; $29c9: $cd $76 $3c
    ld a, [$cc3c]                                 ; $29cc: $fa $3c $cc
    and a                                         ; $29cf: $a7
    jr nz, jr_000_29db                            ; $29d0: $20 $09

Jump_000_29d2:
jr_000_29d2:
    ld a, [$cc47]                                 ; $29d2: $fa $47 $cc
    and a                                         ; $29d5: $a7
    jr nz, jr_000_29db                            ; $29d6: $20 $03

    call Call_000_3882                            ; $29d8: $cd $82 $38

Jump_000_29db:
jr_000_29db:
    call Call_000_019a                            ; $29db: $cd $9a $01
    ldh a, [$b4]                                  ; $29de: $f0 $b4
    bit 0, a                                      ; $29e0: $cb $47
    jr nz, jr_000_29db                            ; $29e2: $20 $f7

Jump_000_29e4:
    ld a, [$d363]                                 ; $29e4: $fa $63 $d3

Call_000_29e7:
    call Call_000_12bc                            ; $29e7: $cd $bc $12
    ld a, $90                                     ; $29ea: $3e $90
    ldh [$b0], a                                  ; $29ec: $e0 $b0
    call Call_000_20ab                            ; $29ee: $cd $ab $20
    call Call_000_20b6                            ; $29f1: $cd $b6 $20
    xor a                                         ; $29f4: $af
    ldh [$ba], a                                  ; $29f5: $e0 $ba
    ld hl, $c219                                  ; $29f7: $21 $19 $c2
    ld c, $0f                                     ; $29fa: $0e $0f
    ld de, $0010                                  ; $29fc: $11 $10 $00

jr_000_29ff:
    ld a, [hl]                                    ; $29ff: $7e
    dec h                                         ; $2a00: $25
    ld [hl], a                                    ; $2a01: $77
    inc h                                         ; $2a02: $24
    add hl, de                                    ; $2a03: $19
    dec c                                         ; $2a04: $0d
    jr nz, jr_000_29ff                            ; $2a05: $20 $f8

    ld a, $05                                     ; $2a07: $3e $05
    ldh [$b8], a                                  ; $2a09: $e0 $b8
    ld [$2000], a                                 ; $2a0b: $ea $00 $20
    call $785b                                    ; $2a0e: $cd $5b $78
    ld hl, $cfc9                                  ; $2a11: $21 $c9 $cf
    res 0, [hl]                                   ; $2a14: $cb $86
    ld a, [$d737]                                 ; $2a16: $fa $37 $d7
    bit 3, a                                      ; $2a19: $cb $5f
    call z, Call_000_0997                         ; $2a1b: $cc $97 $09
    call Call_000_0caa                            ; $2a1e: $cd $aa $0c
    pop af                                        ; $2a21: $f1
    ldh [$b8], a                                  ; $2a22: $e0 $b8
    ld [$2000], a                                 ; $2a24: $ea $00 $20
    jp Jump_000_2425                              ; $2a27: $c3 $25 $24


Jump_000_2a2a:
    push hl                                       ; $2a2a: $e5
    ld hl, $2a51                                  ; $2a2b: $21 $51 $2a
    call Call_000_3c66                            ; $2a2e: $cd $66 $3c
    pop hl                                        ; $2a31: $e1
    inc hl                                        ; $2a32: $23
    call Call_000_2a56                            ; $2a33: $cd $56 $2a
    ld a, $02                                     ; $2a36: $3e $02
    ld [$cf99], a                                 ; $2a38: $ea $99 $cf
    ldh a, [$b8]                                  ; $2a3b: $f0 $b8
    push af                                       ; $2a3d: $f5
    ld a, $01                                     ; $2a3e: $3e $01
    ldh [$b8], a                                  ; $2a40: $e0 $b8
    ld [$2000], a                                 ; $2a42: $ea $00 $20
    call $6cb3                                    ; $2a45: $cd $b3 $6c
    pop af                                        ; $2a48: $f1
    ldh [$b8], a                                  ; $2a49: $e0 $b8
    ld [$2000], a                                 ; $2a4b: $ea $00 $20
    jp Jump_000_29d2                              ; $2a4e: $c3 $d2 $29


    rla                                           ; $2a51: $17
    sub e                                         ; $2a52: $93
    ld l, e                                       ; $2a53: $6b
    jr z, @+$52                                   ; $2a54: $28 $50

Call_000_2a56:
    ld a, $01                                     ; $2a56: $3e $01
    ld [$cfd0], a                                 ; $2a58: $ea $d0 $cf
    ld a, h                                       ; $2a5b: $7c
    ld [$d12d], a                                 ; $2a5c: $ea $2d $d1
    ld a, l                                       ; $2a5f: $7d
    ld [$d12e], a                                 ; $2a60: $ea $2e $d1
    ld de, $cf80                                  ; $2a63: $11 $80 $cf

Jump_000_2a66:
jr_000_2a66:
    ld a, [hl+]                                   ; $2a66: $2a
    ld [de], a                                    ; $2a67: $12
    inc de                                        ; $2a68: $13
    cp $ff                                        ; $2a69: $fe $ff
    jr nz, jr_000_2a66                            ; $2a6b: $20 $f9

    ret                                           ; $2a6d: $c9


Jump_000_2a6e:
    xor a                                         ; $2a6e: $af
    ldh [$8b], a                                  ; $2a6f: $e0 $8b
    ldh [$8c], a                                  ; $2a71: $e0 $8c
    ldh [$8d], a                                  ; $2a73: $e0 $8d
    inc hl                                        ; $2a75: $23
    ldh a, [$b8]                                  ; $2a76: $f0 $b8
    push af                                       ; $2a78: $f5
    ld a, $01                                     ; $2a79: $3e $01
    ldh [$b8], a                                  ; $2a7b: $e0 $b8
    ld [$2000], a                                 ; $2a7d: $ea $00 $20
    call $7079                                    ; $2a80: $cd $79 $70
    pop af                                        ; $2a83: $f1
    ldh [$b8], a                                  ; $2a84: $e0 $b8

Jump_000_2a86:
    ld [$2000], a                                 ; $2a86: $ea $00 $20
    jp Jump_000_29d2                              ; $2a89: $c3 $d2 $29


Jump_000_2a8c:
    ld hl, $69f0                                  ; $2a8c: $21 $f0 $69
    ld b, $07                                     ; $2a8f: $06 $07
    call Call_000_35f3                            ; $2a91: $cd $f3 $35
    jp Jump_000_29d2                              ; $2a94: $c3 $d2 $29


Jump_000_2a97:
    ld hl, $2aa0                                  ; $2a97: $21 $a0 $2a
    call Call_000_3c66                            ; $2a9a: $cd $66 $3c
    jp Jump_000_29d2                              ; $2a9d: $c3 $d2 $29


    rla                                           ; $2aa0: $17
    xor e                                         ; $2aa1: $ab

Jump_000_2aa2:
    ld l, e                                       ; $2aa2: $6b
    jr z, jr_000_2af5                             ; $2aa3: $28 $50

Jump_000_2aa5:
    ld hl, $2ad0                                  ; $2aa5: $21 $d0 $2a
    call Call_000_3c66                            ; $2aa8: $cd $66 $3c
    ld a, [$d737]                                 ; $2aab: $fa $37 $d7
    res 5, a                                      ; $2aae: $cb $af
    ld [$d737], a                                 ; $2ab0: $ea $37 $d7
    ld a, [$d795]                                 ; $2ab3: $fa $95 $d7
    bit 7, a                                      ; $2ab6: $cb $7f
    jr z, jr_000_2acd                             ; $2ab8: $28 $13

    xor a                                         ; $2aba: $af
    ld [$da4c], a                                 ; $2abb: $ea $4c $da
    ld [$d712], a                                 ; $2abe: $ea $12 $d7

Jump_000_2ac1:
    ld [$d713], a                                 ; $2ac1: $ea $13 $d7
    ld [$d795], a                                 ; $2ac4: $ea $95 $d7
    ld [$cf12], a                                 ; $2ac7: $ea $12 $cf
    ld [$d624], a                                 ; $2aca: $ea $24 $d6

jr_000_2acd:
    jp Jump_000_29db                              ; $2acd: $c3 $db $29


    rla                                           ; $2ad0: $17
    cp d                                          ; $2ad1: $ba
    ld l, e                                       ; $2ad2: $6b

Jump_000_2ad3:
    jr z, jr_000_2b25                             ; $2ad3: $28 $50

Jump_000_2ad5:
    ld hl, $2ade                                  ; $2ad5: $21 $de $2a

Jump_000_2ad8:
    call Call_000_3c66                            ; $2ad8: $cd $66 $3c
    jp Jump_000_29d2                              ; $2adb: $c3 $d2 $29


    rla                                           ; $2ade: $17
    sbc $6b                                       ; $2adf: $de $6b
    jr z, @+$52                                   ; $2ae1: $28 $50

Jump_000_2ae3:
    ld a, $04                                     ; $2ae3: $3e $04
    ldh [$b8], a                                  ; $2ae5: $e0 $b8
    ld [$2000], a                                 ; $2ae7: $ea $00 $20
    ld a, [$d705]                                 ; $2aea: $fa $05 $d7
    ld [$d11f], a                                 ; $2aed: $ea $1f $d1
    ld a, $8f                                     ; $2af0: $3e $8f
    call Call_000_23ad                            ; $2af2: $cd $ad $23

Jump_000_2af5:
jr_000_2af5:
    ld b, $01                                     ; $2af5: $06 $01
    ld hl, $719e                                  ; $2af7: $21 $9e $71
    call Call_000_35f3                            ; $2afa: $cd $f3 $35
    ld b, $03                                     ; $2afd: $06 $03
    ld hl, $452f                                  ; $2aff: $21 $2f $45
    call Call_000_35f3                            ; $2b02: $cd $f3 $35
    call Call_000_2425                            ; $2b05: $cd $25 $24

jr_000_2b08:
    call Call_000_3adb                            ; $2b08: $cd $db $3a
    ld b, a                                       ; $2b0b: $47
    bit 6, a                                      ; $2b0c: $cb $77
    jr z, jr_000_2b2e                             ; $2b0e: $28 $1e

    ld a, [$cc26]                                 ; $2b10: $fa $26 $cc
    and a                                         ; $2b13: $a7
    jr nz, jr_000_2b08                            ; $2b14: $20 $f2

    ld a, [$cc2a]                                 ; $2b16: $fa $2a $cc
    and a                                         ; $2b19: $a7
    jr nz, jr_000_2b08                            ; $2b1a: $20 $ec

Jump_000_2b1c:
    ld a, [$d750]                                 ; $2b1c: $fa $50 $d7
    bit 5, a                                      ; $2b1f: $cb $6f
    ld a, $06                                     ; $2b21: $3e $06
    jr nz, jr_000_2b26                            ; $2b23: $20 $01

jr_000_2b25:
    dec a                                         ; $2b25: $3d

jr_000_2b26:
    ld [$cc26], a                                 ; $2b26: $ea $26 $cc
    call Call_000_3c16                            ; $2b29: $cd $16 $3c
    jr jr_000_2b08                                ; $2b2c: $18 $da

jr_000_2b2e:
    bit 7, a                                      ; $2b2e: $cb $7f
    jr z, jr_000_2b4b                             ; $2b30: $28 $19

    ld a, [$d750]                                 ; $2b32: $fa $50 $d7
    bit 5, a                                      ; $2b35: $cb $6f
    ld a, [$cc26]                                 ; $2b37: $fa $26 $cc
    ld c, $07                                     ; $2b3a: $0e $07
    jr nz, jr_000_2b3f                            ; $2b3c: $20 $01

    dec c                                         ; $2b3e: $0d

jr_000_2b3f:
    cp c                                          ; $2b3f: $b9
    jr nz, jr_000_2b08                            ; $2b40: $20 $c6

    xor a                                         ; $2b42: $af
    ld [$cc26], a                                 ; $2b43: $ea $26 $cc
    call Call_000_3c16                            ; $2b46: $cd $16 $3c
    jr jr_000_2b08                                ; $2b49: $18 $bd

jr_000_2b4b:
    call Call_000_3c09                            ; $2b4b: $cd $09 $3c
    ld a, [$cc26]                                 ; $2b4e: $fa $26 $cc
    ld [$cc2d], a                                 ; $2b51: $ea $2d $cc

Call_000_2b54:
    ld a, b                                       ; $2b54: $78
    and $0a                                       ; $2b55: $e6 $0a
    jp nz, Jump_000_2b86                          ; $2b57: $c2 $86 $2b

    call Call_000_3711                            ; $2b5a: $cd $11 $37
    ld a, [$d750]                                 ; $2b5d: $fa $50 $d7
    bit 5, a                                      ; $2b60: $cb $6f
    ld a, [$cc26]                                 ; $2b62: $fa $26 $cc
    jr nz, jr_000_2b68                            ; $2b65: $20 $01

    inc a                                         ; $2b67: $3c

jr_000_2b68:
    cp $00                                        ; $2b68: $fe $00
    jp z, $70a3                                   ; $2b6a: $ca $a3 $70

    cp $01                                        ; $2b6d: $fe $01
    jp z, $70b7                                   ; $2b6f: $ca $b7 $70

    cp $02                                        ; $2b72: $fe $02
    jp z, $7310                                   ; $2b74: $ca $10 $73

    cp $03                                        ; $2b77: $fe $03
    jp z, $746e                                   ; $2b79: $ca $6e $74

    cp $04                                        ; $2b7c: $fe $04
    jp z, $75f2                                   ; $2b7e: $ca $f2 $75

    cp $05                                        ; $2b81: $fe $05
    jp z, $7605                                   ; $2b83: $ca $05 $76

Jump_000_2b86:
jr_000_2b86:
    call Call_000_019a                            ; $2b86: $cd $9a $01
    ldh a, [$b3]                                  ; $2b89: $f0 $b3
    bit 0, a                                      ; $2b8b: $cb $47
    jr nz, jr_000_2b86                            ; $2b8d: $20 $f7

    call Call_000_36bd                            ; $2b8f: $cd $bd $36
    jp Jump_000_29e4                              ; $2b92: $c3 $e4 $29


Call_000_2b95:
    ld c, $00                                     ; $2b95: $0e $00

jr_000_2b97:
    ld a, [hl+]                                   ; $2b97: $2a
    ld e, a                                       ; $2b98: $5f
    ld d, $08                                     ; $2b99: $16 $08

jr_000_2b9b:
    srl e                                         ; $2b9b: $cb $3b
    ld a, $00                                     ; $2b9d: $3e $00
    adc c                                         ; $2b9f: $89
    ld c, a                                       ; $2ba0: $4f
    dec d                                         ; $2ba1: $15
    jr nz, jr_000_2b9b                            ; $2ba2: $20 $f7

    dec b                                         ; $2ba4: $05
    jr nz, jr_000_2b97                            ; $2ba5: $20 $f0

    ld a, c                                       ; $2ba7: $79
    ld [$d123], a                                 ; $2ba8: $ea $23 $d1
    ret                                           ; $2bab: $c9


Call_000_2bac:
    ld b, $01                                     ; $2bac: $06 $01
    ld hl, $6bb4                                  ; $2bae: $21 $b4 $6b
    jp Jump_000_35f3                              ; $2bb1: $c3 $f3 $35


Call_000_2bb4:
    ld de, $d34e                                  ; $2bb4: $11 $4e $d3
    ld hl, $ffa1                                  ; $2bb7: $21 $a1 $ff
    ld c, $03                                     ; $2bba: $0e $03
    ld a, $0b                                     ; $2bbc: $3e $0b
    call Call_000_3e8a                            ; $2bbe: $cd $8a $3e
    ld a, $13                                     ; $2bc1: $3e $13
    ld [$d12a], a                                 ; $2bc3: $ea $2a $d1
    call Call_000_3105                            ; $2bc6: $cd $05 $31
    ld a, $b2                                     ; $2bc9: $3e $b2
    call Call_000_375d                            ; $2bcb: $cd $5d $37
    jp Jump_000_3765                              ; $2bce: $c3 $65 $37


Call_000_2bd1:
Jump_000_2bd1:
    ldh a, [$b8]                                  ; $2bd1: $f0 $b8
    push af                                       ; $2bd3: $f5
    ld a, $03                                     ; $2bd4: $3e $03
    ldh [$b8], a                                  ; $2bd6: $e0 $b8

Jump_000_2bd8:
    ld [$2000], a                                 ; $2bd8: $ea $00 $20
    call $4e74                                    ; $2bdb: $cd $74 $4e
    pop af                                        ; $2bde: $f1
    ldh [$b8], a                                  ; $2bdf: $e0 $b8
    ld [$2000], a                                 ; $2be1: $ea $00 $20
    ret                                           ; $2be4: $c9


Call_000_2be5:
    push bc                                       ; $2be5: $c5
    ldh a, [$b8]                                  ; $2be6: $f0 $b8

Jump_000_2be8:
    push af                                       ; $2be8: $f5
    ld a, $03                                     ; $2be9: $3e $03
    ldh [$b8], a                                  ; $2beb: $e0 $b8
    ld [$2000], a                                 ; $2bed: $ea $00 $20
    call $4e04                                    ; $2bf0: $cd $04 $4e
    pop bc                                        ; $2bf3: $c1
    ld a, b                                       ; $2bf4: $78
    ldh [$b8], a                                  ; $2bf5: $e0 $b8
    ld [$2000], a                                 ; $2bf7: $ea $00 $20
    pop bc                                        ; $2bfa: $c1
    ret                                           ; $2bfb: $c9


Call_000_2bfc:
    xor a                                         ; $2bfc: $af
    ldh [$ba], a                                  ; $2bfd: $e0 $ba
    ld a, $01                                     ; $2bff: $3e $01
    ldh [$b7], a                                  ; $2c01: $e0 $b7
    ld a, [$d05f]                                 ; $2c03: $fa $5f $d0
    and a                                         ; $2c06: $a7
    jr nz, jr_000_2c0d                            ; $2c07: $20 $04

    ld a, $01                                     ; $2c09: $3e $01
    jr jr_000_2c0f                                ; $2c0b: $18 $02

jr_000_2c0d:
    ld a, $0f                                     ; $2c0d: $3e $0f

jr_000_2c0f:
    call Call_000_35d9                            ; $2c0f: $cd $d9 $35
    ld hl, $d735                                  ; $2c12: $21 $35 $d7
    set 6, [hl]                                   ; $2c15: $cb $f6
    xor a                                         ; $2c17: $af
    ld [$cc35], a                                 ; $2c18: $ea $35 $cc
    ld [$d12f], a                                 ; $2c1b: $ea $2f $d1
    ld a, [$cf90]                                 ; $2c1e: $fa $90 $cf
    ld l, a                                       ; $2c21: $6f
    ld a, [$cf91]                                 ; $2c22: $fa $91 $cf
    ld h, a                                       ; $2c25: $67
    ld a, [hl]                                    ; $2c26: $7e
    ld [$d12f], a                                 ; $2c27: $ea $2f $d1
    ld a, $0d                                     ; $2c2a: $3e $0d
    ld [$d12a], a                                 ; $2c2c: $ea $2a $d1
    call Call_000_3105                            ; $2c2f: $cd $05 $31
    call Call_000_2425                            ; $2c32: $cd $25 $24
    ld hl, $c3cc                                  ; $2c35: $21 $cc $c3
    ld de, $090e                                  ; $2c38: $11 $0e $09
    ld a, [$cf99]                                 ; $2c3b: $fa $99 $cf
    and a                                         ; $2c3e: $a7

Call_000_2c3f:
    jr nz, jr_000_2c44                            ; $2c3f: $20 $03

    call Call_000_2425                            ; $2c41: $cd $25 $24

jr_000_2c44:
    ld a, $01                                     ; $2c44: $3e $01
    ld [$cc37], a                                 ; $2c46: $ea $37 $cc
    ld a, [$d12f]                                 ; $2c49: $fa $2f $d1
    cp $02                                        ; $2c4c: $fe $02
    jr c, jr_000_2c52                             ; $2c4e: $38 $02

    ld a, $02                                     ; $2c50: $3e $02

jr_000_2c52:
    ld [$cc28], a                                 ; $2c52: $ea $28 $cc
    ld a, $04                                     ; $2c55: $3e $04
    ld [$cc24], a                                 ; $2c57: $ea $24 $cc
    ld a, $05                                     ; $2c5a: $3e $05
    ld [$cc25], a                                 ; $2c5c: $ea $25 $cc
    ld a, $07                                     ; $2c5f: $3e $07
    ld [$cc29], a                                 ; $2c61: $ea $29 $cc
    ld c, $0a                                     ; $2c64: $0e $0a
    call Call_000_3756                            ; $2c66: $cd $56 $37

Jump_000_2c69:
    xor a                                         ; $2c69: $af
    ldh [$ba], a                                  ; $2c6a: $e0 $ba
    call Call_000_2e75                            ; $2c6c: $cd $75 $2e
    ld a, $01                                     ; $2c6f: $3e $01
    ldh [$ba], a                                  ; $2c71: $e0 $ba
    call Call_000_3df4                            ; $2c73: $cd $f4 $3d
    ld a, [$d05f]                                 ; $2c76: $fa $5f $d0
    and a                                         ; $2c79: $a7
    jr z, jr_000_2c97                             ; $2c7a: $28 $1b

    ld a, $ed                                     ; $2c7c: $3e $ed
    ld [$c3f5], a                                 ; $2c7e: $ea $f5 $c3
    ld c, $50                                     ; $2c81: $0e $50
    call Call_000_3756                            ; $2c83: $cd $56 $37
    xor a                                         ; $2c86: $af
    ld [$cc26], a                                 ; $2c87: $ea $26 $cc
    ld hl, $c3f5                                  ; $2c8a: $21 $f5 $c3
    ld a, l                                       ; $2c8d: $7d
    ld [$cc30], a                                 ; $2c8e: $ea $30 $cc
    ld a, h                                       ; $2c91: $7c
    ld [$cc31], a                                 ; $2c92: $ea $31 $cc
    jr jr_000_2ca7                                ; $2c95: $18 $10

jr_000_2c97:
    call Call_000_20b6                            ; $2c97: $cd $b6 $20
    call Call_000_3adb                            ; $2c9a: $cd $db $3a
    push af                                       ; $2c9d: $f5
    call Call_000_3b99                            ; $2c9e: $cd $99 $3b
    pop af                                        ; $2ca1: $f1
    bit 0, a                                      ; $2ca2: $cb $47
    jp z, Jump_000_2d43                           ; $2ca4: $ca $43 $2d

jr_000_2ca7:
    ld a, [$cc26]                                 ; $2ca7: $fa $26 $cc
    call Call_000_3c09                            ; $2caa: $cd $09 $3c
    ld a, $01                                     ; $2cad: $3e $01
    ld [$d133], a                                 ; $2caf: $ea $33 $d1
    ld [$d132], a                                 ; $2cb2: $ea $32 $d1
    xor a                                         ; $2cb5: $af
    ld [$cc37], a                                 ; $2cb6: $ea $37 $cc
    ld a, [$cc26]                                 ; $2cb9: $fa $26 $cc
    ld c, a                                       ; $2cbc: $4f
    ld a, [$cc36]                                 ; $2cbd: $fa $36 $cc
    add c                                         ; $2cc0: $81
    ld c, a                                       ; $2cc1: $4f
    ld a, [$d12f]                                 ; $2cc2: $fa $2f $d1
    and a                                         ; $2cc5: $a7
    jp z, Jump_000_2e56                           ; $2cc6: $ca $56 $2e

    dec a                                         ; $2cc9: $3d
    cp c                                          ; $2cca: $b9
    jp c, Jump_000_2e56                           ; $2ccb: $da $56 $2e

    ld a, c                                       ; $2cce: $79
    ld [$cf97], a                                 ; $2ccf: $ea $97 $cf
    ld a, [$cf99]                                 ; $2cd2: $fa $99 $cf
    cp $03                                        ; $2cd5: $fe $03
    jr nz, jr_000_2cdb                            ; $2cd7: $20 $02

    sla c                                         ; $2cd9: $cb $21

jr_000_2cdb:
    ld a, [$cf90]                                 ; $2cdb: $fa $90 $cf
    ld l, a                                       ; $2cde: $6f
    ld a, [$cf91]                                 ; $2cdf: $fa $91 $cf
    ld h, a                                       ; $2ce2: $67
    inc hl                                        ; $2ce3: $23
    ld b, $00                                     ; $2ce4: $06 $00
    add hl, bc                                    ; $2ce6: $09
    ld a, [hl]                                    ; $2ce7: $7e
    ld [$cf96], a                                 ; $2ce8: $ea $96 $cf
    ld a, [$cf99]                                 ; $2ceb: $fa $99 $cf
    and a                                         ; $2cee: $a7
    jr z, jr_000_2d12                             ; $2cef: $28 $21

    push hl                                       ; $2cf1: $e5
    call Call_000_37fc                            ; $2cf2: $cd $fc $37
    pop hl                                        ; $2cf5: $e1
    ld a, [$cf99]                                 ; $2cf6: $fa $99 $cf
    cp $03                                        ; $2cf9: $fe $03
    jr nz, jr_000_2d02                            ; $2cfb: $20 $05

    inc hl                                        ; $2cfd: $23
    ld a, [hl]                                    ; $2cfe: $7e
    ld [$cf9c], a                                 ; $2cff: $ea $9c $cf

jr_000_2d02:
    ld a, [$cf96]                                 ; $2d02: $fa $96 $cf
    ld [$d0ba], a                                 ; $2d05: $ea $ba $d0
    ld a, $01                                     ; $2d08: $3e $01
    ld [$d0bc], a                                 ; $2d0a: $ea $bc $d0
    call Call_000_3788                            ; $2d0d: $cd $88 $37
    jr jr_000_2d27                                ; $2d10: $18 $15

jr_000_2d12:
    ld hl, $d168                                  ; $2d12: $21 $68 $d1
    ld a, [$cf90]                                 ; $2d15: $fa $90 $cf
    cp l                                          ; $2d18: $bd
    ld hl, $d2ba                                  ; $2d19: $21 $ba $d2
    jr z, jr_000_2d21                             ; $2d1c: $28 $03

    ld hl, $de0b                                  ; $2d1e: $21 $0b $de

jr_000_2d21:
    ld a, [$cf97]                                 ; $2d21: $fa $97 $cf
    call Call_000_15b7                            ; $2d24: $cd $b7 $15

jr_000_2d27:
    ld de, $cd6d                                  ; $2d27: $11 $6d $cd
    call Call_000_3843                            ; $2d2a: $cd $43 $38
    ld a, $01                                     ; $2d2d: $3e $01
    ld [$d133], a                                 ; $2d2f: $ea $33 $d1
    ld a, [$cc26]                                 ; $2d32: $fa $26 $cc
    ld [$d132], a                                 ; $2d35: $ea $32 $d1
    xor a                                         ; $2d38: $af
    ldh [$b7], a                                  ; $2d39: $e0 $b7
    ld hl, $d735                                  ; $2d3b: $21 $35 $d7
    res 6, [hl]                                   ; $2d3e: $cb $b6
    jp Jump_000_35ea                              ; $2d40: $c3 $ea $35


Jump_000_2d43:
    bit 1, a                                      ; $2d43: $cb $4f
    jp nz, Jump_000_2e56                          ; $2d45: $c2 $56 $2e

    bit 2, a                                      ; $2d48: $cb $57
    jp nz, $6bd7                                  ; $2d4a: $c2 $d7 $6b

    ld b, a                                       ; $2d4d: $47
    bit 7, b                                      ; $2d4e: $cb $78
    ld hl, $cc36                                  ; $2d50: $21 $36 $cc
    jr z, jr_000_2d64                             ; $2d53: $28 $0f

    ld a, [hl]                                    ; $2d55: $7e
    add $03                                       ; $2d56: $c6 $03
    ld b, a                                       ; $2d58: $47
    ld a, [$d12f]                                 ; $2d59: $fa $2f $d1
    cp b                                          ; $2d5c: $b8

Jump_000_2d5d:
    jp c, Jump_000_2c69                           ; $2d5d: $da $69 $2c

    inc [hl]                                      ; $2d60: $34
    jp Jump_000_2c69                              ; $2d61: $c3 $69 $2c


jr_000_2d64:
    ld a, [hl]                                    ; $2d64: $7e
    and a                                         ; $2d65: $a7

Jump_000_2d66:
    jp z, Jump_000_2c69                           ; $2d66: $ca $69 $2c

    dec [hl]                                      ; $2d69: $35
    jp Jump_000_2c69                              ; $2d6a: $c3 $69 $2c


Call_000_2d6d:
    ld hl, $c463                                  ; $2d6d: $21 $63 $c4
    ld b, $01                                     ; $2d70: $06 $01
    ld c, $03                                     ; $2d72: $0e $03
    ld a, [$cf99]                                 ; $2d74: $fa $99 $cf
    cp $02                                        ; $2d77: $fe $02
    jr nz, jr_000_2d82                            ; $2d79: $20 $07

    ld hl, $c45b                                  ; $2d7b: $21 $5b $c4
    ld b, $01                                     ; $2d7e: $06 $01
    ld c, $0b                                     ; $2d80: $0e $0b

jr_000_2d82:
    call Call_000_191f                            ; $2d82: $cd $1f $19
    ld hl, $c478                                  ; $2d85: $21 $78 $c4
    ld a, [$cf99]                                 ; $2d88: $fa $99 $cf
    cp $02                                        ; $2d8b: $fe $02
    jr nz, jr_000_2d97                            ; $2d8d: $20 $08

    ld a, $f0                                     ; $2d8f: $3e $f0
    ld [$c47a], a                                 ; $2d91: $ea $7a $c4
    ld hl, $c470                                  ; $2d94: $21 $70 $c4

jr_000_2d97:
    ld de, $2e4b                                  ; $2d97: $11 $4b $2e
    call Call_000_1952                            ; $2d9a: $cd $52 $19

Jump_000_2d9d:
    xor a                                         ; $2d9d: $af
    ld [$cf9b], a                                 ; $2d9e: $ea $9b $cf
    jp Jump_000_2dbd                              ; $2da1: $c3 $bd $2d


Jump_000_2da4:
jr_000_2da4:
    call Call_000_384e                            ; $2da4: $cd $4e $38
    ldh a, [$b3]                                  ; $2da7: $f0 $b3
    bit 0, a                                      ; $2da9: $cb $47
    jp nz, Jump_000_2e3f                          ; $2dab: $c2 $3f $2e

    bit 1, a                                      ; $2dae: $cb $4f

Call_000_2db0:
    jp nz, Jump_000_2e44                          ; $2db0: $c2 $44 $2e

    bit 6, a                                      ; $2db3: $cb $77
    jr nz, jr_000_2dbd                            ; $2db5: $20 $06

    bit 7, a                                      ; $2db7: $cb $7f
    jr nz, jr_000_2dcf                            ; $2db9: $20 $14

    jr jr_000_2da4                                ; $2dbb: $18 $e7

Jump_000_2dbd:
jr_000_2dbd:
    ld a, [$cf9c]                                 ; $2dbd: $fa $9c $cf
    inc a                                         ; $2dc0: $3c

Call_000_2dc1:
    ld b, a                                       ; $2dc1: $47
    ld hl, $cf9b                                  ; $2dc2: $21 $9b $cf
    inc [hl]                                      ; $2dc5: $34

Jump_000_2dc6:
    ld a, [hl]                                    ; $2dc6: $7e
    cp b                                          ; $2dc7: $b8
    jr nz, jr_000_2dd9                            ; $2dc8: $20 $0f

    ld a, $01                                     ; $2dca: $3e $01
    ld [hl], a                                    ; $2dcc: $77
    jr jr_000_2dd9                                ; $2dcd: $18 $0a

jr_000_2dcf:
    ld hl, $cf9b                                  ; $2dcf: $21 $9b $cf
    dec [hl]                                      ; $2dd2: $35
    jr nz, jr_000_2dd9                            ; $2dd3: $20 $04

    ld a, [$cf9c]                                 ; $2dd5: $fa $9c $cf
    ld [hl], a                                    ; $2dd8: $77

jr_000_2dd9:
    ld hl, $c479                                  ; $2dd9: $21 $79 $c4
    ld a, [$cf99]                                 ; $2ddc: $fa $99 $cf
    cp $02                                        ; $2ddf: $fe $02
    jr nz, jr_000_2e33                            ; $2de1: $20 $50

    ld c, $03                                     ; $2de3: $0e $03
    ld a, [$cf9b]                                 ; $2de5: $fa $9b $cf
    ld b, a                                       ; $2de8: $47

Call_000_2de9:
    ld hl, $ff9f                                  ; $2de9: $21 $9f $ff
    xor a                                         ; $2dec: $af
    ld [hl+], a                                   ; $2ded: $22
    ld [hl+], a                                   ; $2dee: $22
    ld [hl], a                                    ; $2def: $77

jr_000_2df0:
    ld de, $ffa1                                  ; $2df0: $11 $a1 $ff
    ld hl, $ff8d                                  ; $2df3: $21 $8d $ff
    push bc                                       ; $2df6: $c5
    ld a, $0b                                     ; $2df7: $3e $0b
    call Call_000_3e8a                            ; $2df9: $cd $8a $3e
    pop bc                                        ; $2dfc: $c1
    dec b                                         ; $2dfd: $05
    jr nz, jr_000_2df0                            ; $2dfe: $20 $f0

    ldh a, [$8e]                                  ; $2e00: $f0 $8e
    and a                                         ; $2e02: $a7
    jr z, jr_000_2e1f                             ; $2e03: $28 $1a

    xor a                                         ; $2e05: $af

Call_000_2e06:
    ldh [$a2], a                                  ; $2e06: $e0 $a2
    ldh [$a3], a                                  ; $2e08: $e0 $a3
    ld a, $02                                     ; $2e0a: $3e $02
    ldh [$a4], a                                  ; $2e0c: $e0 $a4
    ld a, $0d                                     ; $2e0e: $3e $0d
    call Call_000_3e8a                            ; $2e10: $cd $8a $3e
    ldh a, [$a2]                                  ; $2e13: $f0 $a2
    ldh [$9f], a                                  ; $2e15: $e0 $9f
    ldh a, [$a3]                                  ; $2e17: $f0 $a3
    ldh [$a0], a                                  ; $2e19: $e0 $a0
    ldh a, [$a4]                                  ; $2e1b: $f0 $a4
    ldh [$a1], a                                  ; $2e1d: $e0 $a1

jr_000_2e1f:
    ld hl, $c474                                  ; $2e1f: $21 $74 $c4
    ld de, $2e4f                                  ; $2e22: $11 $4f $2e
    call Call_000_1952                            ; $2e25: $cd $52 $19
    ld de, $ff9f                                  ; $2e28: $11 $9f $ff
    ld c, $83                                     ; $2e2b: $0e $83
    call Call_000_15ca                            ; $2e2d: $cd $ca $15
    ld hl, $c471                                  ; $2e30: $21 $71 $c4

jr_000_2e33:
    ld de, $cf9b                                  ; $2e33: $11 $9b $cf
    ld bc, $8102                                  ; $2e36: $01 $02 $81
    call Call_000_3c7c                            ; $2e39: $cd $7c $3c
    jp Jump_000_2da4                              ; $2e3c: $c3 $a4 $2d


Jump_000_2e3f:
    xor a                                         ; $2e3f: $af
    ld [$cc35], a                                 ; $2e40: $ea $35 $cc
    ret                                           ; $2e43: $c9


Jump_000_2e44:
    xor a                                         ; $2e44: $af
    ld [$cc35], a                                 ; $2e45: $ea $35 $cc
    ld a, $ff                                     ; $2e48: $3e $ff
    ret                                           ; $2e4a: $c9


    pop af                                        ; $2e4b: $f1
    or $f7                                        ; $2e4c: $f6 $f7
    ld d, b                                       ; $2e4e: $50
    ld a, a                                       ; $2e4f: $7f

Call_000_2e50:
    ld a, a                                       ; $2e50: $7f
    ld a, a                                       ; $2e51: $7f
    ld a, a                                       ; $2e52: $7f
    ld a, a                                       ; $2e53: $7f
    ld a, a                                       ; $2e54: $7f
    ld d, b                                       ; $2e55: $50

Jump_000_2e56:
    ld a, [$cc26]                                 ; $2e56: $fa $26 $cc
    ld [$d132], a                                 ; $2e59: $ea $32 $d1
    ld a, $02                                     ; $2e5c: $3e $02

Call_000_2e5e:
    ld [$d133], a                                 ; $2e5e: $ea $33 $d1
    ld [$cc37], a                                 ; $2e61: $ea $37 $cc
    xor a                                         ; $2e64: $af
    ldh [$b7], a                                  ; $2e65: $e0 $b7
    ld hl, $d735                                  ; $2e67: $21 $35 $d7
    res 6, [hl]                                   ; $2e6a: $cb $b6
    call Call_000_35ea                            ; $2e6c: $cd $ea $35
    xor a                                         ; $2e6f: $af
    ld [$cc35], a                                 ; $2e70: $ea $35 $cc
    scf                                           ; $2e73: $37
    ret                                           ; $2e74: $c9


Call_000_2e75:
    ld hl, $c3e1                                  ; $2e75: $21 $e1 $c3
    ld b, $09                                     ; $2e78: $06 $09
    ld c, $0e                                     ; $2e7a: $0e $0e
    call Call_000_18c1                            ; $2e7c: $cd $c1 $18
    ld a, [$cf90]                                 ; $2e7f: $fa $90 $cf
    ld e, a                                       ; $2e82: $5f
    ld a, [$cf91]                                 ; $2e83: $fa $91 $cf
    ld d, a                                       ; $2e86: $57
    inc de                                        ; $2e87: $13
    ld a, [$cc36]                                 ; $2e88: $fa $36 $cc
    ld c, a                                       ; $2e8b: $4f
    ld a, [$cf99]                                 ; $2e8c: $fa $99 $cf
    cp $03                                        ; $2e8f: $fe $03
    ld a, c                                       ; $2e91: $79
    jr nz, jr_000_2e98                            ; $2e92: $20 $04

    sla a                                         ; $2e94: $cb $27
    sla c                                         ; $2e96: $cb $21

jr_000_2e98:
    add e                                         ; $2e98: $83
    ld e, a                                       ; $2e99: $5f
    jr nc, jr_000_2e9d                            ; $2e9a: $30 $01

    inc d                                         ; $2e9c: $14

jr_000_2e9d:
    ld hl, $c3f6                                  ; $2e9d: $21 $f6 $c3
    ld b, $04                                     ; $2ea0: $06 $04

Jump_000_2ea2:
    ld a, b                                       ; $2ea2: $78
    ld [$cf97], a                                 ; $2ea3: $ea $97 $cf
    ld a, [de]                                    ; $2ea6: $1a
    ld [$d123], a                                 ; $2ea7: $ea $23 $d1
    cp $ff                                        ; $2eaa: $fe $ff
    jp z, Jump_000_2fae                           ; $2eac: $ca $ae $2f

    push bc                                       ; $2eaf: $c5
    push de                                       ; $2eb0: $d5
    push hl                                       ; $2eb1: $e5
    push hl                                       ; $2eb2: $e5
    push de                                       ; $2eb3: $d5
    ld a, [$cf99]                                 ; $2eb4: $fa $99 $cf
    and a                                         ; $2eb7: $a7
    jr z, jr_000_2ec3                             ; $2eb8: $28 $09

    cp $01                                        ; $2eba: $fe $01
    jr z, jr_000_2ee5                             ; $2ebc: $28 $27

    call Call_000_2fec                            ; $2ebe: $cd $ec $2f
    jr jr_000_2ee8                                ; $2ec1: $18 $25

jr_000_2ec3:
    push hl                                       ; $2ec3: $e5
    ld hl, $d168                                  ; $2ec4: $21 $68 $d1
    ld a, [$cf90]                                 ; $2ec7: $fa $90 $cf
    cp l                                          ; $2eca: $bd
    ld hl, $d2ba                                  ; $2ecb: $21 $ba $d2
    jr z, jr_000_2ed3                             ; $2ece: $28 $03

    ld hl, $de0b                                  ; $2ed0: $21 $0b $de

jr_000_2ed3:
    ld a, [$cf97]                                 ; $2ed3: $fa $97 $cf
    ld b, a                                       ; $2ed6: $47
    ld a, $04                                     ; $2ed7: $3e $04
    sub b                                         ; $2ed9: $90
    ld b, a                                       ; $2eda: $47
    ld a, [$cc36]                                 ; $2edb: $fa $36 $cc
    add b                                         ; $2ede: $80
    call Call_000_15b7                            ; $2edf: $cd $b7 $15
    pop hl                                        ; $2ee2: $e1
    jr jr_000_2ee8                                ; $2ee3: $18 $03

jr_000_2ee5:
    call Call_000_3075                            ; $2ee5: $cd $75 $30

jr_000_2ee8:
    call Call_000_1952                            ; $2ee8: $cd $52 $19
    pop de                                        ; $2eeb: $d1
    pop hl                                        ; $2eec: $e1
    ld a, [$cf98]                                 ; $2eed: $fa $98 $cf

Call_000_2ef0:
    and a                                         ; $2ef0: $a7
    jr z, jr_000_2f0a                             ; $2ef1: $28 $17

    push hl                                       ; $2ef3: $e5
    ld a, [de]                                    ; $2ef4: $1a

Call_000_2ef5:
    ld de, $460a                                  ; $2ef5: $11 $0a $46
    ld [$cf96], a                                 ; $2ef8: $ea $96 $cf
    call Call_000_37fc                            ; $2efb: $cd $fc $37
    pop hl                                        ; $2efe: $e1
    ld bc, $0019                                  ; $2eff: $01 $19 $00

Call_000_2f02:
    add hl, bc                                    ; $2f02: $09
    ld c, $83                                     ; $2f03: $0e $83
    call Call_000_15ca                            ; $2f05: $cd $ca $15
    ld [hl], $f0                                  ; $2f08: $36 $f0

jr_000_2f0a:
    ld a, [$cf99]                                 ; $2f0a: $fa $99 $cf
    and a                                         ; $2f0d: $a7
    jr nz, jr_000_2f4e                            ; $2f0e: $20 $3e

    ld a, [$d123]                                 ; $2f10: $fa $23 $d1
    push af                                       ; $2f13: $f5
    push hl                                       ; $2f14: $e5
    ld hl, $d168                                  ; $2f15: $21 $68 $d1
    ld a, [$cf90]                                 ; $2f18: $fa $90 $cf
    cp l                                          ; $2f1b: $bd
    ld a, $00                                     ; $2f1c: $3e $00
    jr z, jr_000_2f22                             ; $2f1e: $28 $02

    ld a, $02                                     ; $2f20: $3e $02

jr_000_2f22:
    ld [$cc49], a                                 ; $2f22: $ea $49 $cc
    ld hl, $cf97                                  ; $2f25: $21 $97 $cf
    ld a, [hl]                                    ; $2f28: $7e
    ld b, a                                       ; $2f29: $47
    ld a, $04                                     ; $2f2a: $3e $04
    sub b                                         ; $2f2c: $90
    ld b, a                                       ; $2f2d: $47
    ld a, [$cc36]                                 ; $2f2e: $fa $36 $cc
    add b                                         ; $2f31: $80

Jump_000_2f32:
    ld [hl], a                                    ; $2f32: $77
    call Call_000_1372                            ; $2f33: $cd $72 $13
    ld a, [$cc49]                                 ; $2f36: $fa $49 $cc
    and a                                         ; $2f39: $a7
    jr z, jr_000_2f42                             ; $2f3a: $28 $06

    ld a, [$cfa0]                                 ; $2f3c: $fa $a0 $cf
    ld [$cfbe], a                                 ; $2f3f: $ea $be $cf

jr_000_2f42:
    pop hl                                        ; $2f42: $e1
    ld bc, $001c                                  ; $2f43: $01 $1c $00
    add hl, bc                                    ; $2f46: $09
    call Call_000_1508                            ; $2f47: $cd $08 $15
    pop af                                        ; $2f4a: $f1
    ld [$d123], a                                 ; $2f4b: $ea $23 $d1

jr_000_2f4e:
    pop hl                                        ; $2f4e: $e1
    pop de                                        ; $2f4f: $d1
    inc de                                        ; $2f50: $13
    ld a, [$cf99]                                 ; $2f51: $fa $99 $cf
    cp $03                                        ; $2f54: $fe $03
    jr nz, jr_000_2f9c                            ; $2f56: $20 $44

    ld a, [$d123]                                 ; $2f58: $fa $23 $d1
    ld [$cf96], a                                 ; $2f5b: $ea $96 $cf
    call Call_000_30f6                            ; $2f5e: $cd $f6 $30
    ld a, [$d129]                                 ; $2f61: $fa $29 $d1
    and a                                         ; $2f64: $a7
    jr nz, jr_000_2f88                            ; $2f65: $20 $21

    push hl                                       ; $2f67: $e5
    ld bc, $001c                                  ; $2f68: $01 $1c $00
    add hl, bc                                    ; $2f6b: $09
    ld a, $f1                                     ; $2f6c: $3e $f1
    ld [hl+], a                                   ; $2f6e: $22
    ld a, [$d123]                                 ; $2f6f: $fa $23 $d1
    push af                                       ; $2f72: $f5
    ld a, [de]                                    ; $2f73: $1a
    ld [$cf9c], a                                 ; $2f74: $ea $9c $cf
    push de                                       ; $2f77: $d5
    ld de, $d123                                  ; $2f78: $11 $23 $d1
    ld [de], a                                    ; $2f7b: $12

Call_000_2f7c:
    ld bc, $0102                                  ; $2f7c: $01 $02 $01
    call Call_000_3c7c                            ; $2f7f: $cd $7c $3c
    pop de                                        ; $2f82: $d1
    pop af                                        ; $2f83: $f1
    ld [$d123], a                                 ; $2f84: $ea $23 $d1
    pop hl                                        ; $2f87: $e1

jr_000_2f88:
    inc de                                        ; $2f88: $13
    pop bc                                        ; $2f89: $c1
    inc c                                         ; $2f8a: $0c
    push bc                                       ; $2f8b: $c5
    inc c                                         ; $2f8c: $0c
    ld a, [$cc35]                                 ; $2f8d: $fa $35 $cc
    and a                                         ; $2f90: $a7
    jr z, jr_000_2f9c                             ; $2f91: $28 $09

    sla a                                         ; $2f93: $cb $27
    cp c                                          ; $2f95: $b9
    jr nz, jr_000_2f9c                            ; $2f96: $20 $04

    dec hl                                        ; $2f98: $2b
    ld a, $ec                                     ; $2f99: $3e $ec
    ld [hl+], a                                   ; $2f9b: $22

jr_000_2f9c:
    ld bc, $0028                                  ; $2f9c: $01 $28 $00
    add hl, bc                                    ; $2f9f: $09
    pop bc                                        ; $2fa0: $c1
    inc c                                         ; $2fa1: $0c
    dec b                                         ; $2fa2: $05
    jp nz, Jump_000_2ea2                          ; $2fa3: $c2 $a2 $2e

Call_000_2fa6:
    ld bc, $fff8                                  ; $2fa6: $01 $f8 $ff
    add hl, bc                                    ; $2fa9: $09
    ld a, $ee                                     ; $2faa: $3e $ee
    ld [hl], a                                    ; $2fac: $77
    ret                                           ; $2fad: $c9


Jump_000_2fae:
    ld de, $2fb4                                  ; $2fae: $11 $b4 $2f
    jp Jump_000_1952                              ; $2fb1: $c3 $52 $19


    sub c                                         ; $2fb4: $91
    add h                                         ; $2fb5: $84
    sub e                                         ; $2fb6: $93
    adc [hl]                                      ; $2fb7: $8e
    sub h                                         ; $2fb8: $94
    sub c                                         ; $2fb9: $91
    ld d, b                                       ; $2fba: $50

Call_000_2fbb:
Jump_000_2fbb:
    push hl                                       ; $2fbb: $e5
    ldh a, [$b8]                                  ; $2fbc: $f0 $b8
    push af                                       ; $2fbe: $f5
    ld a, $07                                     ; $2fbf: $3e $07
    ldh [$b8], a                                  ; $2fc1: $e0 $b8
    ld [$2000], a                                 ; $2fc3: $ea $00 $20
    ld a, [$d123]                                 ; $2fc6: $fa $23 $d1
    dec a                                         ; $2fc9: $3d
    ld hl, $421e                                  ; $2fca: $21 $1e $42
    ld c, $0a                                     ; $2fcd: $0e $0a
    ld b, $00                                     ; $2fcf: $06 $00
    call Call_000_3aa4                            ; $2fd1: $cd $a4 $3a
    ld de, $cd6d                                  ; $2fd4: $11 $6d $cd
    push de                                       ; $2fd7: $d5
    ld bc, $000a                                  ; $2fd8: $01 $0a $00
    call Call_000_00b5                            ; $2fdb: $cd $b5 $00
    ld hl, $cd77                                  ; $2fde: $21 $77 $cd
    ld [hl], $50                                  ; $2fe1: $36 $50
    pop de                                        ; $2fe3: $d1
    pop af                                        ; $2fe4: $f1
    ldh [$b8], a                                  ; $2fe5: $e0 $b8
    ld [$2000], a                                 ; $2fe7: $ea $00 $20
    pop hl                                        ; $2fea: $e1
    ret                                           ; $2feb: $c9


Call_000_2fec:
    push hl                                       ; $2fec: $e5
    push bc                                       ; $2fed: $c5
    ld a, [$d123]                                 ; $2fee: $fa $23 $d1
    cp $c4                                        ; $2ff1: $fe $c4
    jr nc, jr_000_3007                            ; $2ff3: $30 $12

    ld [$d0ba], a                                 ; $2ff5: $ea $ba $d0
    ld a, $04                                     ; $2ff8: $3e $04
    ld [$d0bb], a                                 ; $2ffa: $ea $bb $d0
    ld a, $01                                     ; $2ffd: $3e $01
    ld [$d0bc], a                                 ; $2fff: $ea $bc $d0
    call Call_000_3788                            ; $3002: $cd $88 $37
    jr jr_000_300a                                ; $3005: $18 $03

jr_000_3007:
    call Call_000_3010                            ; $3007: $cd $10 $30

jr_000_300a:
    ld de, $cd6d                                  ; $300a: $11 $6d $cd
    pop bc                                        ; $300d: $c1
    pop hl                                        ; $300e: $e1
    ret                                           ; $300f: $c9


Call_000_3010:
Jump_000_3010:
    push hl                                       ; $3010: $e5
    push de                                       ; $3011: $d5
    push bc                                       ; $3012: $c5
    ld a, [$d123]                                 ; $3013: $fa $23 $d1
    push af                                       ; $3016: $f5
    cp $c9                                        ; $3017: $fe $c9
    jr nc, jr_000_3028                            ; $3019: $30 $0d

    add $05                                       ; $301b: $c6 $05
    ld [$d123], a                                 ; $301d: $ea $23 $d1
    ld hl, $305b                                  ; $3020: $21 $5b $30
    ld bc, $0002                                  ; $3023: $01 $02 $00
    jr jr_000_302e                                ; $3026: $18 $06

jr_000_3028:
    ld hl, $3059                                  ; $3028: $21 $59 $30
    ld bc, $0002                                  ; $302b: $01 $02 $00

jr_000_302e:
    ld de, $cd6d                                  ; $302e: $11 $6d $cd
    call Call_000_00b5                            ; $3031: $cd $b5 $00

Call_000_3034:
    ld a, [$d123]                                 ; $3034: $fa $23 $d1
    sub $c8                                       ; $3037: $d6 $c8
    ld b, $f6                                     ; $3039: $06 $f6

jr_000_303b:
    sub $0a                                       ; $303b: $d6 $0a
    jr c, jr_000_3042                             ; $303d: $38 $03

    inc b                                         ; $303f: $04

Jump_000_3040:
    jr jr_000_303b                                ; $3040: $18 $f9

jr_000_3042:
    add $0a                                       ; $3042: $c6 $0a
    push af                                       ; $3044: $f5
    ld a, b                                       ; $3045: $78
    ld [de], a                                    ; $3046: $12
    inc de                                        ; $3047: $13
    pop af                                        ; $3048: $f1
    ld b, $f6                                     ; $3049: $06 $f6
    add b                                         ; $304b: $80
    ld [de], a                                    ; $304c: $12
    inc de                                        ; $304d: $13
    ld a, $50                                     ; $304e: $3e $50
    ld [de], a                                    ; $3050: $12
    pop af                                        ; $3051: $f1

Call_000_3052:
    ld [$d123], a                                 ; $3052: $ea $23 $d1
    pop bc                                        ; $3055: $c1
    pop de                                        ; $3056: $d1
    pop hl                                        ; $3057: $e1
    ret                                           ; $3058: $c9


    add d                                         ; $3059: $82
    sub e                                         ; $305a: $93
    add d                                         ; $305b: $82
    sub d                                         ; $305c: $92

Call_000_305d:
    cp $c4                                        ; $305d: $fe $c4
    jr c, jr_000_3064                             ; $305f: $38 $03

Jump_000_3061:
    cp $c9                                        ; $3061: $fe $c9
    ret                                           ; $3063: $c9


jr_000_3064:
    and a                                         ; $3064: $a7
    ret                                           ; $3065: $c9


Call_000_3066:
    ld hl, $306f                                  ; $3066: $21 $6f $30
    ld de, $0001                                  ; $3069: $11 $01 $00
    jp Jump_000_3dc8                              ; $306c: $c3 $c8 $3d


    rrca                                          ; $306f: $0f
    inc de                                        ; $3070: $13
    add hl, sp                                    ; $3071: $39
    ld b, [hl]                                    ; $3072: $46
    sub h                                         ; $3073: $94
    rst $38                                       ; $3074: $ff

Call_000_3075:
    push hl                                       ; $3075: $e5
    ld a, $02                                     ; $3076: $3e $02
    ld [$d0bb], a                                 ; $3078: $ea $bb $d0
    ld a, [$d123]                                 ; $307b: $fa $23 $d1
    ld [$d0ba], a                                 ; $307e: $ea $ba $d0
    ld a, $2c                                     ; $3081: $3e $2c
    ld [$d0bc], a                                 ; $3083: $ea $bc $d0
    call Call_000_3788                            ; $3086: $cd $88 $37
    ld de, $cd6d                                  ; $3089: $11 $6d $cd
    pop hl                                        ; $308c: $e1
    ret                                           ; $308d: $c9


Call_000_308e:
Jump_000_308e:
    ldh a, [$b8]                                  ; $308e: $f0 $b8
    push af                                       ; $3090: $f5
    ld a, [$d363]                                 ; $3091: $fa $63 $d3
    call Call_000_12bc                            ; $3094: $cd $bc $12
    call Call_000_0061                            ; $3097: $cd $61 $00
    call Call_000_36bd                            ; $309a: $cd $bd $36
    call Call_000_0caa                            ; $309d: $cd $aa $0c
    call Call_000_09e8                            ; $30a0: $cd $e8 $09
    call Call_000_007b                            ; $30a3: $cd $7b $00
    pop af                                        ; $30a6: $f1
    ldh [$b8], a                                  ; $30a7: $e0 $b8
    ld [$2000], a                                 ; $30a9: $ea $00 $20
    ret                                           ; $30ac: $c9


Call_000_30ad:
Jump_000_30ad:
    ldh a, [$b8]                                  ; $30ad: $f0 $b8
    push af                                       ; $30af: $f5
    ld a, [$d363]                                 ; $30b0: $fa $63 $d3
    call Call_000_12bc                            ; $30b3: $cd $bc $12
    call Call_000_0061                            ; $30b6: $cd $61 $00
    call Call_000_09e8                            ; $30b9: $cd $e8 $09
    call Call_000_007b                            ; $30bc: $cd $7b $00
    pop af                                        ; $30bf: $f1
    ldh [$b8], a                                  ; $30c0: $e0 $b8

Call_000_30c2:
    ld [$2000], a                                 ; $30c2: $ea $00 $20
    ret                                           ; $30c5: $c9


Call_000_30c6:
    ld hl, $d733                                  ; $30c6: $21 $33 $d7
    res 4, [hl]                                   ; $30c9: $cb $a6
    ld b, $1c                                     ; $30cb: $06 $1c
    ld hl, $4f93                                  ; $30cd: $21 $93 $4f
    jp Jump_000_35f3                              ; $30d0: $c3 $f3 $35


Call_000_30d3:
    ld a, $01                                     ; $30d3: $3e $01
    ld [$cc3c], a                                 ; $30d5: $ea $3c $cc
    ret                                           ; $30d8: $c9


Call_000_30d9:
    ld b, $03                                     ; $30d9: $06 $03
    ld hl, $55c7                                  ; $30db: $21 $c7 $55
    jp Jump_000_35f3                              ; $30de: $c3 $f3 $35


Call_000_30e1:
    ldh a, [$b8]                                  ; $30e1: $f0 $b8
    push af                                       ; $30e3: $f5
    ld a, $03                                     ; $30e4: $3e $03
    ldh [$b8], a                                  ; $30e6: $e0 $b8
    ld [$2000], a                                 ; $30e8: $ea $00 $20
    call $66e1                                    ; $30eb: $cd $e1 $66
    pop de                                        ; $30ee: $d1

Jump_000_30ef:
    ld a, d                                       ; $30ef: $7a
    ldh [$b8], a                                  ; $30f0: $e0 $b8
    ld [$2000], a                                 ; $30f2: $ea $00 $20
    ret                                           ; $30f5: $c9


Call_000_30f6:
    push hl                                       ; $30f6: $e5
    push de                                       ; $30f7: $d5
    push bc                                       ; $30f8: $c5
    ld b, $03                                     ; $30f9: $06 $03
    ld hl, $6754                                  ; $30fb: $21 $54 $67
    call Call_000_35f3                            ; $30fe: $cd $f3 $35
    pop bc                                        ; $3101: $c1
    pop de                                        ; $3102: $d1
    pop hl                                        ; $3103: $e1
    ret                                           ; $3104: $c9


Call_000_3105:
Jump_000_3105:
    ldh a, [$b8]                                  ; $3105: $f0 $b8
    push af                                       ; $3107: $f5
    ld a, $01                                     ; $3108: $3e $01
    ldh [$b8], a                                  ; $310a: $e0 $b8
    ld [$2000], a                                 ; $310c: $ea $00 $20
    call $737e                                    ; $310f: $cd $7e $73
    pop bc                                        ; $3112: $c1
    ld a, b                                       ; $3113: $78
    ldh [$b8], a                                  ; $3114: $e0 $b8
    ld [$2000], a                                 ; $3116: $ea $00 $20
    ret                                           ; $3119: $c9


Call_000_311a:
    ld a, [$cc57]                                 ; $311a: $fa $57 $cc
    and a                                         ; $311d: $a7
    ret nz                                        ; $311e: $c0

    ld a, [$d73b]                                 ; $311f: $fa $3b $d7
    bit 1, a                                      ; $3122: $cb $4f

Call_000_3124:
    ret nz                                        ; $3124: $c0

    ld a, [$d735]                                 ; $3125: $fa $35 $d7
    and $80                                       ; $3128: $e6 $80
    ret                                           ; $312a: $c9


Call_000_312b:
    ld hl, $d73b                                  ; $312b: $21 $3b $d7
    bit 0, [hl]                                   ; $312e: $cb $46
    res 0, [hl]                                   ; $3130: $cb $86
    jr nz, jr_000_3163                            ; $3132: $20 $2f

    ld a, [$cc57]                                 ; $3134: $fa $57 $cc
    and a                                         ; $3137: $a7
    ret z                                         ; $3138: $c8

    dec a                                         ; $3139: $3d
    add a                                         ; $313a: $87
    ld d, $00                                     ; $313b: $16 $00
    ld e, a                                       ; $313d: $5f
    ld hl, $315d                                  ; $313e: $21 $5d $31

Jump_000_3141:
    add hl, de                                    ; $3141: $19
    ld a, [hl+]                                   ; $3142: $2a
    ld h, [hl]                                    ; $3143: $66
    ld l, a                                       ; $3144: $6f

Jump_000_3145:
    ldh a, [$b8]                                  ; $3145: $f0 $b8
    push af                                       ; $3147: $f5
    ld a, [$cc58]                                 ; $3148: $fa $58 $cc
    ldh [$b8], a                                  ; $314b: $e0 $b8
    ld [$2000], a                                 ; $314d: $ea $00 $20
    ld a, [$cf15]                                 ; $3150: $fa $15 $cf
    call Call_000_3db4                            ; $3153: $cd $b4 $3d
    pop af                                        ; $3156: $f1
    ldh [$b8], a                                  ; $3157: $e0 $b8
    ld [$2000], a                                 ; $3159: $ea $00 $20
    ret                                           ; $315c: $c9


    ld b, a                                       ; $315d: $47
    ld h, h                                       ; $315e: $64
    dec d                                         ; $315f: $15

Call_000_3160:
    ld h, l                                       ; $3160: $65
    add d                                         ; $3161: $82
    ld h, l                                       ; $3162: $65

jr_000_3163:
    ld b, $06                                     ; $3163: $06 $06
    ld hl, $63e5                                  ; $3165: $21 $e5 $63
    jp Jump_000_35f3                              ; $3168: $c3 $f3 $35


Jump_000_316b:
    ld b, $06                                     ; $316b: $06 $06
    ld hl, $6422                                  ; $316d: $21 $22 $64
    jp Jump_000_35f3                              ; $3170: $c3 $f3 $35


    ret                                           ; $3173: $c9


Call_000_3174:
    ld a, h                                       ; $3174: $7c
    ld [$da35], a                                 ; $3175: $ea $35 $da
    ld a, l                                       ; $3178: $7d
    ld [$da36], a                                 ; $3179: $ea $36 $da
    ret                                           ; $317c: $c9


Call_000_317d:
    push af                                       ; $317d: $f5
    push de                                       ; $317e: $d5
    call Call_000_3174                            ; $317f: $cd $74 $31
    pop hl                                        ; $3182: $e1
    pop af                                        ; $3183: $f1
    push hl                                       ; $3184: $e5
    ld hl, $d738                                  ; $3185: $21 $38 $d7
    bit 4, [hl]                                   ; $3188: $cb $66
    res 4, [hl]                                   ; $318a: $cb $a6

Call_000_318c:
    jr z, jr_000_3191                             ; $318c: $28 $03

    ld a, [$da3e]                                 ; $318e: $fa $3e $da

jr_000_3191:
    pop hl                                        ; $3191: $e1
    ld [$da3e], a                                 ; $3192: $ea $3e $da

Jump_000_3195:
    call Call_000_3db4                            ; $3195: $cd $b4 $3d

Call_000_3198:
    ld a, [$da3e]                                 ; $3198: $fa $3e $da
    ret                                           ; $319b: $c9


Call_000_319c:
Jump_000_319c:
    push de                                       ; $319c: $d5
    ld de, $cf64                                  ; $319d: $11 $64 $cf
    ld bc, $0011                                  ; $31a0: $01 $11 $00
    call Call_000_00b5                            ; $31a3: $cd $b5 $00
    pop hl                                        ; $31a6: $e1
    ld de, $cf75                                  ; $31a7: $11 $75 $cf
    ld bc, $000b                                  ; $31aa: $01 $0b $00
    jp Jump_000_00b5                              ; $31ad: $c3 $b5 $00


Call_000_31b0:
    push de                                       ; $31b0: $d5
    push af                                       ; $31b1: $f5
    ld d, $00                                     ; $31b2: $16 $00
    ld e, a                                       ; $31b4: $5f
    ld hl, $da35                                  ; $31b5: $21 $35 $da
    ld a, [hl+]                                   ; $31b8: $2a
    ld l, [hl]                                    ; $31b9: $6e
    ld h, a                                       ; $31ba: $67
    add hl, de                                    ; $31bb: $19
    pop af                                        ; $31bc: $f1
    and a                                         ; $31bd: $a7
    jr nz, jr_000_31c6                            ; $31be: $20 $06

    ld a, [hl]                                    ; $31c0: $7e
    ld [$cc55], a                                 ; $31c1: $ea $55 $cc
    jr jr_000_31e2                                ; $31c4: $18 $1c

jr_000_31c6:
    cp $02                                        ; $31c6: $fe $02

Call_000_31c8:
    jr z, jr_000_31df                             ; $31c8: $28 $15

    cp $04                                        ; $31ca: $fe $04
    jr z, jr_000_31df                             ; $31cc: $28 $11

    cp $06                                        ; $31ce: $fe $06
    jr z, jr_000_31df                             ; $31d0: $28 $0d

    cp $08                                        ; $31d2: $fe $08
    jr z, jr_000_31df                             ; $31d4: $28 $09

    cp $0a                                        ; $31d6: $fe $0a
    jr nz, jr_000_31e2                            ; $31d8: $20 $08

    ld a, [hl+]                                   ; $31da: $2a
    ld d, [hl]                                    ; $31db: $56
    ld e, a                                       ; $31dc: $5f
    jr jr_000_31e2                                ; $31dd: $18 $03

jr_000_31df:
    ld a, [hl+]                                   ; $31df: $2a
    ld h, [hl]                                    ; $31e0: $66
    ld l, a                                       ; $31e1: $6f

jr_000_31e2:
    pop de                                        ; $31e2: $d1
    ret                                           ; $31e3: $c9


Call_000_31e4:
    ld a, $10                                     ; $31e4: $3e $10
    jp Jump_000_3e8a                              ; $31e6: $c3 $8a $3e


Call_000_31e9:
    call Call_000_3174                            ; $31e9: $cd $74 $31
    xor a                                         ; $31ec: $af
    call Call_000_31b0                            ; $31ed: $cd $b0 $31

Jump_000_31f0:
    ld a, $02                                     ; $31f0: $3e $02
    call Call_000_31b0                            ; $31f2: $cd $b0 $31
    ld a, [$cc55]                                 ; $31f5: $fa $55 $cc
    ld c, a                                       ; $31f8: $4f
    ld b, $02                                     ; $31f9: $06 $02
    call Call_000_31e4                            ; $31fb: $cd $e4 $31

Call_000_31fe:
    ld a, c                                       ; $31fe: $79
    and a                                         ; $31ff: $a7
    jr z, jr_000_320a                             ; $3200: $28 $08

    ld a, $06                                     ; $3202: $3e $06
    call Call_000_31b0                            ; $3204: $cd $b0 $31
    jp Jump_000_3c66                              ; $3207: $c3 $66 $3c


jr_000_320a:
    ld a, $04                                     ; $320a: $3e $04
    call Call_000_31b0                            ; $320c: $cd $b0 $31
    call Call_000_3c66                            ; $320f: $cd $66 $3c
    ld a, $0a                                     ; $3212: $3e $0a
    call Call_000_31b0                            ; $3214: $cd $b0 $31
    push de                                       ; $3217: $d5
    ld a, $08                                     ; $3218: $3e $08
    call Call_000_31b0                            ; $321a: $cd $b0 $31
    pop de                                        ; $321d: $d1
    call Call_000_3371                            ; $321e: $cd $71 $33
    ld hl, $d738                                  ; $3221: $21 $38 $d7
    set 4, [hl]                                   ; $3224: $cb $e6
    ld hl, $cd60                                  ; $3226: $21 $60 $cd
    bit 0, [hl]                                   ; $3229: $cb $46
    ret nz                                        ; $322b: $c0

    call Call_000_3387                            ; $322c: $cd $87 $33
    ld hl, $da3e                                  ; $322f: $21 $3e $da
    inc [hl]                                      ; $3232: $34
    jp Jump_000_327a                              ; $3233: $c3 $7a $32


Call_000_3236:
Jump_000_3236:
    call Call_000_3323                            ; $3236: $cd $23 $33
    ld a, [$cf18]                                 ; $3239: $fa $18 $cf
    cp $ff                                        ; $323c: $fe $ff
    jr nz, jr_000_3248                            ; $323e: $20 $08

    xor a                                         ; $3240: $af
    ld [$cf18], a                                 ; $3241: $ea $18 $cf
    ld [$cc55], a                                 ; $3244: $ea $55 $cc

Call_000_3247:
    ret                                           ; $3247: $c9


jr_000_3248:
    ld hl, $d738                                  ; $3248: $21 $38 $d7
    set 3, [hl]                                   ; $324b: $cb $de
    ld [$cd4f], a                                 ; $324d: $ea $4f $cd
    xor a                                         ; $3250: $af
    ld [$cd50], a                                 ; $3251: $ea $50 $cd
    ld a, $4c                                     ; $3254: $3e $4c
    call Call_000_3e8a                            ; $3256: $cd $8a $3e
    ld a, $f0                                     ; $3259: $3e $f0
    ld [$cd6b], a                                 ; $325b: $ea $6b $cd
    xor a                                         ; $325e: $af
    ldh [$b4], a                                  ; $325f: $e0 $b4
    call Call_000_32ec                            ; $3261: $cd $ec $32
    ld hl, $da3e                                  ; $3264: $21 $3e $da
    inc [hl]                                      ; $3267: $34
    ret                                           ; $3268: $c9


    ld a, [$d735]                                 ; $3269: $fa $35 $d7
    and $01                                       ; $326c: $e6 $01
    ret nz                                        ; $326e: $c0

    ld [$cd6b], a                                 ; $326f: $ea $6b $cd
    ld a, [$cf18]                                 ; $3272: $fa $18 $cf
    ldh [$8c], a                                  ; $3275: $e0 $8c
    call Call_000_291c                            ; $3277: $cd $1c $29

Jump_000_327a:
    xor a                                         ; $327a: $af
    ld [$cd6b], a                                 ; $327b: $ea $6b $cd
    call Call_000_32f4                            ; $327e: $cd $f4 $32
    ld hl, $d732                                  ; $3281: $21 $32 $d7
    set 6, [hl]                                   ; $3284: $cb $f6
    set 7, [hl]                                   ; $3286: $cb $fe
    ld hl, $d733                                  ; $3288: $21 $33 $d7
    set 1, [hl]                                   ; $328b: $cb $ce
    ld hl, $da3e                                  ; $328d: $21 $3e $da
    inc [hl]                                      ; $3290: $34
    ret                                           ; $3291: $c9


Call_000_3292:
    ld hl, $d12b                                  ; $3292: $21 $2b $d1
    set 5, [hl]                                   ; $3295: $cb $ee
    set 6, [hl]                                   ; $3297: $cb $f6
    ld hl, $d732                                  ; $3299: $21 $32 $d7
    res 7, [hl]                                   ; $329c: $cb $be
    ld hl, $cd60                                  ; $329e: $21 $60 $cd
    res 0, [hl]                                   ; $32a1: $cb $86
    ld a, [$d05c]                                 ; $32a3: $fa $5c $d0
    cp $ff                                        ; $32a6: $fe $ff
    jp z, Jump_000_32de                           ; $32a8: $ca $de $32

    ld a, $02                                     ; $32ab: $3e $02
    call Call_000_31b0                            ; $32ad: $cd $b0 $31
    ld a, [$cc55]                                 ; $32b0: $fa $55 $cc
    ld c, a                                       ; $32b3: $4f
    ld b, $01                                     ; $32b4: $06 $01
    call Call_000_31e4                            ; $32b6: $cd $e4 $31
    ld a, [$d718]                                 ; $32b9: $fa $18 $d7
    cp $c8                                        ; $32bc: $fe $c8

Call_000_32be:
Jump_000_32be:
    jr nc, jr_000_32d6                            ; $32be: $30 $16

    ld hl, $d5d3                                  ; $32c0: $21 $d3 $d5
    ld de, $0002                                  ; $32c3: $11 $02 $00
    ld a, [$cf18]                                 ; $32c6: $fa $18 $cf

Call_000_32c9:
    call Call_000_3dc8                            ; $32c9: $cd $c8 $3d
    inc hl                                        ; $32cc: $23
    ld a, [hl]                                    ; $32cd: $7e
    ld [$cc4d], a                                 ; $32ce: $ea $4d $cc
    ld a, $11                                     ; $32d1: $3e $11
    call Call_000_3e8a                            ; $32d3: $cd $8a $3e

jr_000_32d6:
    ld hl, $d735                                  ; $32d6: $21 $35 $d7
    bit 4, [hl]                                   ; $32d9: $cb $66
    res 4, [hl]                                   ; $32db: $cb $a6
    ret nz                                        ; $32dd: $c0

Jump_000_32de:
    xor a                                         ; $32de: $af
    ld [$cd6b], a                                 ; $32df: $ea $6b $cd
    ldh [$b4], a                                  ; $32e2: $e0 $b4
    ldh [$b3], a                                  ; $32e4: $e0 $b3
    ldh [$b2], a                                  ; $32e6: $e0 $b2
    ld [$da3e], a                                 ; $32e8: $ea $3e $da
    ret                                           ; $32eb: $c9


Call_000_32ec:
    ld b, $15                                     ; $32ec: $06 $15
    ld hl, $687a                                  ; $32ee: $21 $7a $68
    jp Jump_000_35f3                              ; $32f1: $c3 $f3 $35


Call_000_32f4:
    ld a, [$cd2d]                                 ; $32f4: $fa $2d $cd
    ld [$d05e], a                                 ; $32f7: $ea $5e $d0
    ld [$d718], a                                 ; $32fa: $ea $18 $d7
    cp $c8                                        ; $32fd: $fe $c8
    ld a, [$cd2e]                                 ; $32ff: $fa $2e $cd
    jr c, jr_000_3308                             ; $3302: $38 $04

    ld [$d062], a                                 ; $3304: $ea $62 $d0
    ret                                           ; $3307: $c9


jr_000_3308:
    ld [$d12c], a                                 ; $3308: $ea $2c $d1

Jump_000_330b:
    ret                                           ; $330b: $c9


Call_000_330c:
    ld hl, $67f2                                  ; $330c: $21 $f2 $67
    jr jr_000_331e                                ; $330f: $18 $0d

Call_000_3311:
    ld hl, $6812                                  ; $3311: $21 $12 $68
    jr jr_000_331e                                ; $3314: $18 $08

Call_000_3316:
    ld hl, $6836                                  ; $3316: $21 $36 $68
    jr jr_000_331e                                ; $3319: $18 $03

Call_000_331b:
    ld hl, $6856                                  ; $331b: $21 $56 $68

jr_000_331e:
    ld b, $15                                     ; $331e: $06 $15
    jp Jump_000_35f3                              ; $3320: $c3 $f3 $35


Call_000_3323:
    xor a                                         ; $3323: $af
    call Call_000_31b0                            ; $3324: $cd $b0 $31

Call_000_3327:
    ld d, h                                       ; $3327: $54
    ld e, l                                       ; $3328: $5d

jr_000_3329:
    call Call_000_3174                            ; $3329: $cd $74 $31
    ld a, [de]                                    ; $332c: $1a
    ld [$cf18], a                                 ; $332d: $ea $18 $cf
    ld [$cc55], a                                 ; $3330: $ea $55 $cc
    cp $ff                                        ; $3333: $fe $ff
    ret z                                         ; $3335: $c8

    ld a, $02                                     ; $3336: $3e $02
    call Call_000_31b0                            ; $3338: $cd $b0 $31
    ld b, $02                                     ; $333b: $06 $02
    ld a, [$cc55]                                 ; $333d: $fa $55 $cc
    ld c, a                                       ; $3340: $4f

Jump_000_3341:
    call Call_000_31e4                            ; $3341: $cd $e4 $31
    ld a, c                                       ; $3344: $79

Jump_000_3345:
    and a                                         ; $3345: $a7
    jr nz, jr_000_3369                            ; $3346: $20 $21

    push hl                                       ; $3348: $e5
    push de                                       ; $3349: $d5
    push hl                                       ; $334a: $e5
    xor a                                         ; $334b: $af
    call Call_000_31b0                            ; $334c: $cd $b0 $31
    inc hl                                        ; $334f: $23
    ld a, [hl]                                    ; $3350: $7e
    pop hl                                        ; $3351: $e1
    ld [$cd3e], a                                 ; $3352: $ea $3e $cd
    ld a, [$cf18]                                 ; $3355: $fa $18 $cf
    swap a                                        ; $3358: $cb $37

Call_000_335a:
    ld [$cd3d], a                                 ; $335a: $ea $3d $cd
    ld a, $39                                     ; $335d: $3e $39
    call Call_000_3e8a                            ; $335f: $cd $8a $3e
    pop de                                        ; $3362: $d1
    pop hl                                        ; $3363: $e1
    ld a, [$cd3d]                                 ; $3364: $fa $3d $cd
    and a                                         ; $3367: $a7
    ret nz                                        ; $3368: $c0

jr_000_3369:
    ld hl, $000c                                  ; $3369: $21 $0c $00
    add hl, de                                    ; $336c: $19
    ld d, h                                       ; $336d: $54
    ld e, l                                       ; $336e: $5d
    jr jr_000_3329                                ; $336f: $18 $b8

Call_000_3371:
    ldh a, [$b8]                                  ; $3371: $f0 $b8
    ld [$d097], a                                 ; $3373: $ea $97 $d0
    ld a, h                                       ; $3376: $7c
    ld [$d091], a                                 ; $3377: $ea $91 $d0
    ld a, l                                       ; $337a: $7d
    ld [$d092], a                                 ; $337b: $ea $92 $d0
    ld a, d                                       ; $337e: $7a
    ld [$d093], a                                 ; $337f: $ea $93 $d0
    ld a, e                                       ; $3382: $7b
    ld [$d094], a                                 ; $3383: $ea $94 $d0
    ret                                           ; $3386: $c9


Call_000_3387:
    ld hl, $d509                                  ; $3387: $21 $09 $d5

Call_000_338a:
    ld d, $00                                     ; $338a: $16 $00
    ld a, [$cf18]                                 ; $338c: $fa $18 $cf
    dec a                                         ; $338f: $3d
    add a                                         ; $3390: $87
    ld e, a                                       ; $3391: $5f
    add hl, de                                    ; $3392: $19
    ld a, [hl+]                                   ; $3393: $2a
    ld [$cd2d], a                                 ; $3394: $ea $2d $cd

Call_000_3397:
    ld a, [hl]                                    ; $3397: $7e
    ld [$cd2e], a                                 ; $3398: $ea $2e $cd

Call_000_339b:
    jp Jump_000_3405                              ; $339b: $c3 $05 $34


Call_000_339e:
    push hl                                       ; $339e: $e5
    ld hl, $d732                                  ; $339f: $21 $32 $d7
    bit 7, [hl]                                   ; $33a2: $cb $7e
    res 7, [hl]                                   ; $33a4: $cb $be
    pop hl                                        ; $33a6: $e1

Call_000_33a7:
    ret z                                         ; $33a7: $c8

    ldh a, [$b8]                                  ; $33a8: $f0 $b8
    push af                                       ; $33aa: $f5
    ld a, [$d097]                                 ; $33ab: $fa $97 $d0
    ldh [$b8], a                                  ; $33ae: $e0 $b8
    ld [$2000], a                                 ; $33b0: $ea $00 $20

Call_000_33b3:
    push hl                                       ; $33b3: $e5
    ld b, $09                                     ; $33b4: $06 $09
    ld hl, $7e47                                  ; $33b6: $21 $47 $7e
    call Call_000_35f3                            ; $33b9: $cd $f3 $35
    ld hl, $33ec                                  ; $33bc: $21 $ec $33
    call Call_000_3c66                            ; $33bf: $cd $66 $3c

Call_000_33c2:
    pop hl                                        ; $33c2: $e1
    pop af                                        ; $33c3: $f1
    ldh [$b8], a                                  ; $33c4: $e0 $b8
    ld [$2000], a                                 ; $33c6: $ea $00 $20
    ld b, $06                                     ; $33c9: $06 $06
    ld hl, $65ec                                  ; $33cb: $21 $ec $65
    call Call_000_35f3                            ; $33ce: $cd $f3 $35
    jp Jump_000_3765                              ; $33d1: $c3 $65 $37


Call_000_33d4:
    ld a, [$cf10]                                 ; $33d4: $fa $10 $cf
    and a                                         ; $33d7: $a7
    jr nz, jr_000_33e3                            ; $33d8: $20 $09

    ld a, [$d091]                                 ; $33da: $fa $91 $d0
    ld h, a                                       ; $33dd: $67
    ld a, [$d092]                                 ; $33de: $fa $92 $d0
    ld l, a                                       ; $33e1: $6f
    ret                                           ; $33e2: $c9


jr_000_33e3:
    ld a, [$d093]                                 ; $33e3: $fa $93 $d0
    ld h, a                                       ; $33e6: $67
    ld a, [$d094]                                 ; $33e7: $fa $94 $d0
    ld l, a                                       ; $33ea: $6f
    ret                                           ; $33eb: $c9


    rla                                           ; $33ec: $17
    ld c, h                                       ; $33ed: $4c
    ld b, b                                       ; $33ee: $40
    jr nz, @+$0a                                  ; $33ef: $20 $08

    call Call_000_33d4                            ; $33f1: $cd $d4 $33
    call Call_000_1b3c                            ; $33f4: $cd $3c $1b
    jp Jump_000_24d3                              ; $33f7: $c3 $d3 $24


    ld a, [$cd60]                                 ; $33fa: $fa $60 $cd
    bit 0, a                                      ; $33fd: $cb $47
    ret nz                                        ; $33ff: $c0

    call Call_000_3387                            ; $3400: $cd $87 $33
    xor a                                         ; $3403: $af
    ret                                           ; $3404: $c9


Jump_000_3405:
    ld a, [$cd2d]                                 ; $3405: $fa $2d $cd

Call_000_3408:
    cp $e1                                        ; $3408: $fe $e1
    ret z                                         ; $340a: $c8

    cp $f2                                        ; $340b: $fe $f2
    ret z                                         ; $340d: $c8

Jump_000_340e:
    cp $f3                                        ; $340e: $fe $f3
    ret z                                         ; $3410: $c8

    ld a, [$d061]                                 ; $3411: $fa $61 $d0
    and a                                         ; $3414: $a7
    ret nz                                        ; $3415: $c0

    xor a                                         ; $3416: $af
    ld [$cfcc], a                                 ; $3417: $ea $cc $cf
    ld a, $ff                                     ; $341a: $3e $ff
    call Call_000_23ad                            ; $341c: $cd $ad $23
    ld a, $1f                                     ; $341f: $3e $1f
    ld [$c0ef], a                                 ; $3421: $ea $ef $c0
    ld [$c0f0], a                                 ; $3424: $ea $f0 $c0
    ld a, [$cd2d]                                 ; $3427: $fa $2d $cd
    ld b, a                                       ; $342a: $47
    ld hl, $3456                                  ; $342b: $21 $56 $34

jr_000_342e:
    ld a, [hl+]                                   ; $342e: $2a
    cp $ff                                        ; $342f: $fe $ff
    jr z, jr_000_343a                             ; $3431: $28 $07

    cp b                                          ; $3433: $b8

Call_000_3434:
    jr nz, jr_000_342e                            ; $3434: $20 $f8

    ld a, $f6                                     ; $3436: $3e $f6
    jr jr_000_344b                                ; $3438: $18 $11

jr_000_343a:
    ld hl, $3451                                  ; $343a: $21 $51 $34

jr_000_343d:
    ld a, [hl+]                                   ; $343d: $2a
    cp $ff                                        ; $343e: $fe $ff
    jr z, jr_000_3449                             ; $3440: $28 $07

    cp b                                          ; $3442: $b8
    jr nz, jr_000_343d                            ; $3443: $20 $f8

    ld a, $f9                                     ; $3445: $3e $f9
    jr jr_000_344b                                ; $3447: $18 $02

jr_000_3449:
    ld a, $fc                                     ; $3449: $3e $fc

jr_000_344b:
    ld [$c0ee], a                                 ; $344b: $ea $ee $c0
    jp Jump_000_23ad                              ; $344e: $c3 $ad $23


    set 1, [hl]                                   ; $3451: $cb $ce
    jp c, $ffe8                                   ; $3453: $da $e8 $ff

    push de                                       ; $3456: $d5
    reti                                          ; $3457: $d9


    call c, $e3dd                                 ; $3458: $dc $dd $e3
    db $e4                                        ; $345b: $e4
    push hl                                       ; $345c: $e5
    and $ff                                       ; $345d: $e6 $ff

Call_000_345f:
jr_000_345f:
    ld a, [hl+]                                   ; $345f: $2a
    cp $ff                                        ; $3460: $fe $ff
    ret z                                         ; $3462: $c8

    cp b                                          ; $3463: $b8
    jr nz, jr_000_3478                            ; $3464: $20 $12

    ld a, [hl+]                                   ; $3466: $2a
    cp c                                          ; $3467: $b9
    jr nz, jr_000_3479                            ; $3468: $20 $0f

    ld a, [hl+]                                   ; $346a: $2a
    ld d, [hl]                                    ; $346b: $56
    ld e, a                                       ; $346c: $5f
    ld hl, $ccd3                                  ; $346d: $21 $d3 $cc
    call Call_000_3529                            ; $3470: $cd $29 $35
    dec a                                         ; $3473: $3d
    ld [$cd38], a                                 ; $3474: $ea $38 $cd
    ret                                           ; $3477: $c9


jr_000_3478:
    inc hl                                        ; $3478: $23

jr_000_3479:
    inc hl                                        ; $3479: $23
    inc hl                                        ; $347a: $23
    jr jr_000_345f                                ; $347b: $18 $e2

Jump_000_347d:
    call Call_000_3711                            ; $347d: $cd $11 $37
    ld b, $01                                     ; $3480: $06 $01
    ld hl, $7950                                  ; $3482: $21 $50 $79
    jr jr_000_3496                                ; $3485: $18 $0f

Jump_000_3487:
    call Call_000_3711                            ; $3487: $cd $11 $37
    ld b, $08                                     ; $348a: $06 $08
    ld hl, $54c5                                  ; $348c: $21 $c5 $54
    jr jr_000_3496                                ; $348f: $18 $05

Jump_000_3491:
    ld b, $14                                     ; $3491: $06 $14
    ld hl, $671e                                  ; $3493: $21 $1e $67

jr_000_3496:
    call Call_000_35f3                            ; $3496: $cd $f3 $35
    jp Jump_000_29db                              ; $3499: $c3 $db $29


Jump_000_349c:
    ld b, $05                                     ; $349c: $06 $05
    ld hl, $7e1d                                  ; $349e: $21 $1d $7e
    jr jr_000_3496                                ; $34a1: $18 $f3

Call_000_34a3:
Jump_000_34a3:
    xor a                                         ; $34a3: $af
    ld [$cd3b], a                                 ; $34a4: $ea $3b $cd
    ld [$c206], a                                 ; $34a7: $ea $06 $c2
    ld hl, $d735                                  ; $34aa: $21 $35 $d7
    set 7, [hl]                                   ; $34ad: $cb $fe
    ret                                           ; $34af: $c9


Call_000_34b0:
Jump_000_34b0:
    ld a, $1c                                     ; $34b0: $3e $1c
    call Call_000_3e8a                            ; $34b2: $cd $8a $3e
    ld a, b                                       ; $34b5: $78
    and a                                         ; $34b6: $a7
    ret                                           ; $34b7: $c9


Call_000_34b8:
    ld [$d123], a                                 ; $34b8: $ea $23 $d1
    ld b, $01                                     ; $34bb: $06 $01
    ld hl, $7c89                                  ; $34bd: $21 $89 $7c
    jp Jump_000_35f3                              ; $34c0: $c3 $f3 $35


Call_000_34c3:
Jump_000_34c3:
    call Call_000_34cb                            ; $34c3: $cd $cb $34
    ld c, $06                                     ; $34c6: $0e $06
    jp Jump_000_3756                              ; $34c8: $c3 $56 $37


Call_000_34cb:
    ld a, $09                                     ; $34cb: $3e $09
    ldh [$8b], a                                  ; $34cd: $e0 $8b
    call Call_000_3519                            ; $34cf: $cd $19 $35
    ldh a, [$8d]                                  ; $34d2: $f0 $8d
    ld [hl], a                                    ; $34d4: $77
    ret                                           ; $34d5: $c9


Call_000_34d6:
    ld de, $fff9                                  ; $34d6: $11 $f9 $ff
    add hl, de                                    ; $34d9: $19
    ld [hl], a                                    ; $34da: $77
    ret                                           ; $34db: $c9


Call_000_34dc:
    ld a, [$d366]                                 ; $34dc: $fa $66 $d3
    ld b, a                                       ; $34df: $47
    ld a, [$d367]                                 ; $34e0: $fa $67 $d3
    ld c, a                                       ; $34e3: $4f

Jump_000_34e4:
    xor a                                         ; $34e4: $af
    ld [$cd3d], a                                 ; $34e5: $ea $3d $cd

jr_000_34e8:
    ld a, [hl+]                                   ; $34e8: $2a
    cp $ff                                        ; $34e9: $fe $ff
    jr z, jr_000_34ff                             ; $34eb: $28 $12

    push hl                                       ; $34ed: $e5
    ld hl, $cd3d                                  ; $34ee: $21 $3d $cd
    inc [hl]                                      ; $34f1: $34
    pop hl                                        ; $34f2: $e1
    cp b                                          ; $34f3: $b8
    jr z, jr_000_34f9                             ; $34f4: $28 $03

    inc hl                                        ; $34f6: $23
    jr jr_000_34e8                                ; $34f7: $18 $ef

jr_000_34f9:
    ld a, [hl+]                                   ; $34f9: $2a
    cp c                                          ; $34fa: $b9
    jr nz, jr_000_34e8                            ; $34fb: $20 $eb

Call_000_34fd:
Jump_000_34fd:
    scf                                           ; $34fd: $37
    ret                                           ; $34fe: $c9


jr_000_34ff:
    and a                                         ; $34ff: $a7
    ret                                           ; $3500: $c9


Call_000_3501:
    push hl                                       ; $3501: $e5
    ld hl, $c204                                  ; $3502: $21 $04 $c2
    ldh a, [$8c]                                  ; $3505: $f0 $8c
    swap a                                        ; $3507: $cb $37
    ld d, $00                                     ; $3509: $16 $00
    ld e, a                                       ; $350b: $5f
    add hl, de                                    ; $350c: $19
    ld a, [hl+]                                   ; $350d: $2a

Jump_000_350e:
    sub $04                                       ; $350e: $d6 $04
    ld b, a                                       ; $3510: $47
    ld a, [hl]                                    ; $3511: $7e
    sub $04                                       ; $3512: $d6 $04
    ld c, a                                       ; $3514: $4f
    pop hl                                        ; $3515: $e1
    jp Jump_000_34e4                              ; $3516: $c3 $e4 $34


Call_000_3519:
    ld h, $c1                                     ; $3519: $26 $c1
    jr jr_000_351f                                ; $351b: $18 $02

Call_000_351d:
    ld h, $c2                                     ; $351d: $26 $c2

jr_000_351f:
    ldh a, [$8b]                                  ; $351f: $f0 $8b
    ld b, a                                       ; $3521: $47
    ldh a, [$8c]                                  ; $3522: $f0 $8c
    swap a                                        ; $3524: $cb $37
    add b                                         ; $3526: $80
    ld l, a                                       ; $3527: $6f
    ret                                           ; $3528: $c9


Call_000_3529:
    xor a                                         ; $3529: $af
    ld [$ccd2], a                                 ; $352a: $ea $d2 $cc

jr_000_352d:
    ld a, [de]                                    ; $352d: $1a
    cp $ff                                        ; $352e: $fe $ff
    jr z, jr_000_3548                             ; $3530: $28 $16

    ldh [$8b], a                                  ; $3532: $e0 $8b
    inc de                                        ; $3534: $13
    ld a, [de]                                    ; $3535: $1a
    ld b, $00                                     ; $3536: $06 $00
    ld c, a                                       ; $3538: $4f
    ld a, [$ccd2]                                 ; $3539: $fa $d2 $cc
    add c                                         ; $353c: $81
    ld [$ccd2], a                                 ; $353d: $ea $d2 $cc
    ldh a, [$8b]                                  ; $3540: $f0 $8b
    call Call_000_36fd                            ; $3542: $cd $fd $36
    inc de                                        ; $3545: $13
    jr jr_000_352d                                ; $3546: $18 $e5

jr_000_3548:
    ld a, $ff                                     ; $3548: $3e $ff
    ld [hl], a                                    ; $354a: $77
    ld a, [$ccd2]                                 ; $354b: $fa $d2 $cc
    inc a                                         ; $354e: $3c
    ret                                           ; $354f: $c9


    push hl                                       ; $3550: $e5
    call Call_000_356b                            ; $3551: $cd $6b $35
    ld [hl], $fe                                  ; $3554: $36 $fe
    call Call_000_3575                            ; $3556: $cd $75 $35
    ldh a, [$8d]                                  ; $3559: $f0 $8d
    ld [hl], a                                    ; $355b: $77
    pop hl                                        ; $355c: $e1
    ret                                           ; $355d: $c9


Call_000_355e:
Jump_000_355e:
    push hl                                       ; $355e: $e5
    call Call_000_356b                            ; $355f: $cd $6b $35
    ld [hl], $ff                                  ; $3562: $36 $ff
    call Call_000_3575                            ; $3564: $cd $75 $35
    ld [hl], $ff                                  ; $3567: $36 $ff
    pop hl                                        ; $3569: $e1
    ret                                           ; $356a: $c9


Call_000_356b:
    ld h, $c2                                     ; $356b: $26 $c2
    ldh a, [$8c]                                  ; $356d: $f0 $8c
    swap a                                        ; $356f: $cb $37
    add $06                                       ; $3571: $c6 $06
    ld l, a                                       ; $3573: $6f
    ret                                           ; $3574: $c9


Call_000_3575:
    push de                                       ; $3575: $d5
    ld hl, $d4e9                                  ; $3576: $21 $e9 $d4
    ldh a, [$8c]                                  ; $3579: $f0 $8c
    dec a                                         ; $357b: $3d
    add a                                         ; $357c: $87
    ld d, $00                                     ; $357d: $16 $00
    ld e, a                                       ; $357f: $5f
    add hl, de                                    ; $3580: $19

Jump_000_3581:
    pop de                                        ; $3581: $d1
    ret                                           ; $3582: $c9


Call_000_3583:
    call Call_000_35bb                            ; $3583: $cd $bb $35
    ld a, [$d130]                                 ; $3586: $fa $30 $d1
    and a                                         ; $3589: $a7
    jr nz, jr_000_35b1                            ; $358a: $20 $25

    ld a, $0e                                     ; $358c: $3e $0e
    call Call_000_35d9                            ; $358e: $cd $d9 $35
    ld a, [$d036]                                 ; $3591: $fa $36 $d0
    dec a                                         ; $3594: $3d
    ld hl, $5914                                  ; $3595: $21 $14 $59
    ld bc, $0005                                  ; $3598: $01 $05 $00
    call Call_000_3aa4                            ; $359b: $cd $a4 $3a
    ld de, $d038                                  ; $359e: $11 $38 $d0
    ld a, [hl+]                                   ; $35a1: $2a
    ld [de], a                                    ; $35a2: $12

Call_000_35a3:
    inc de                                        ; $35a3: $13
    ld a, [hl+]                                   ; $35a4: $2a
    ld [de], a                                    ; $35a5: $12
    ld de, $d04b                                  ; $35a6: $11 $4b $d0
    ld a, [hl+]                                   ; $35a9: $2a
    ld [de], a                                    ; $35aa: $12
    inc de                                        ; $35ab: $13
    ld a, [hl+]                                   ; $35ac: $2a
    ld [de], a                                    ; $35ad: $12
    jp Jump_000_35ea                              ; $35ae: $c3 $ea $35


jr_000_35b1:
    ld hl, $d038                                  ; $35b1: $21 $38 $d0
    ld de, $6eec                                  ; $35b4: $11 $ec $6e
    ld [hl], e                                    ; $35b7: $73
    inc hl                                        ; $35b8: $23
    ld [hl], d                                    ; $35b9: $72
    ret                                           ; $35ba: $c9


Call_000_35bb:
    ld b, $04                                     ; $35bb: $06 $04
    ld hl, $7a69                                  ; $35bd: $21 $69 $7a
    jp Jump_000_35f3                              ; $35c0: $c3 $f3 $35


Call_000_35c3:
    ld de, $d34c                                  ; $35c3: $11 $4c $d3
    ld hl, $ff9f                                  ; $35c6: $21 $9f $ff
    ld c, $03                                     ; $35c9: $0e $03
    jp Jump_000_3aab                              ; $35cb: $c3 $ab $3a


Call_000_35ce:
Jump_000_35ce:
    ld de, $d5a9                                  ; $35ce: $11 $a9 $d5
    ld hl, $ffa0                                  ; $35d1: $21 $a0 $ff
    ld c, $02                                     ; $35d4: $0e $02
    jp Jump_000_3aab                              ; $35d6: $c3 $ab $3a


Call_000_35d9:
    ld [$cf0e], a                                 ; $35d9: $ea $0e $cf
    ldh a, [$b8]                                  ; $35dc: $f0 $b8
    ld [$cf0d], a                                 ; $35de: $ea $0d $cf
    ld a, [$cf0e]                                 ; $35e1: $fa $0e $cf
    ldh [$b8], a                                  ; $35e4: $e0 $b8

Call_000_35e6:
    ld [$2000], a                                 ; $35e6: $ea $00 $20
    ret                                           ; $35e9: $c9


Call_000_35ea:
Jump_000_35ea:
    ld a, [$cf0d]                                 ; $35ea: $fa $0d $cf
    ldh [$b8], a                                  ; $35ed: $e0 $b8
    ld [$2000], a                                 ; $35ef: $ea $00 $20
    ret                                           ; $35f2: $c9


Call_000_35f3:
Jump_000_35f3:
    ldh a, [$b8]                                  ; $35f3: $f0 $b8
    push af                                       ; $35f5: $f5
    ld a, b                                       ; $35f6: $78
    ldh [$b8], a                                  ; $35f7: $e0 $b8
    ld [$2000], a                                 ; $35f9: $ea $00 $20
    ld bc, $3601                                  ; $35fc: $01 $01 $36
    push bc                                       ; $35ff: $c5
    jp hl                                         ; $3600: $e9


    pop bc                                        ; $3601: $c1
    ld a, b                                       ; $3602: $78
    ldh [$b8], a                                  ; $3603: $e0 $b8
    ld [$2000], a                                 ; $3605: $ea $00 $20
    ret                                           ; $3608: $c9


Call_000_3609:
    call Call_000_3736                            ; $3609: $cd $36 $37
    call Call_000_361c                            ; $360c: $cd $1c $36
    jr jr_000_3645                                ; $360f: $18 $34

    ld a, $14                                     ; $3611: $3e $14
    ld [$d12a], a                                 ; $3613: $ea $2a $d1
    call Call_000_361c                            ; $3616: $cd $1c $36
    jp Jump_000_3105                              ; $3619: $c3 $05 $31


Call_000_361c:
    xor a                                         ; $361c: $af

Jump_000_361d:
    ld [$d131], a                                 ; $361d: $ea $31 $d1
    ld hl, $c43a                                  ; $3620: $21 $3a $c4
    ld bc, $080f                                  ; $3623: $01 $0f $08

Jump_000_3626:
    ret                                           ; $3626: $c9


Call_000_3627:
    call Call_000_3736                            ; $3627: $cd $36 $37
    ld a, $06                                     ; $362a: $3e $06

Call_000_362c:
    ld [$d131], a                                 ; $362c: $ea $31 $d1
    ld hl, $c423                                  ; $362f: $21 $23 $c4
    ld bc, $080c                                  ; $3632: $01 $0c $08
    jr jr_000_3645                                ; $3635: $18 $0e

    call Call_000_3736                            ; $3637: $cd $36 $37
    ld a, $03                                     ; $363a: $3e $03
    ld [$d131], a                                 ; $363c: $ea $31 $d1
    ld hl, $c438                                  ; $363f: $21 $38 $c4
    ld bc, $080d                                  ; $3642: $01 $0d $08

jr_000_3645:
    ld a, $14                                     ; $3645: $3e $14
    ld [$d12a], a                                 ; $3647: $ea $2a $d1
    call Call_000_3105                            ; $364a: $cd $05 $31
    jp Jump_000_3742                              ; $364d: $c3 $42 $37


Call_000_3650:
    sub b                                         ; $3650: $90
    ret nc                                        ; $3651: $d0

    cpl                                           ; $3652: $2f
    add $01                                       ; $3653: $c6 $01
    scf                                           ; $3655: $37
    ret                                           ; $3656: $c9


Call_000_3657:
Jump_000_3657:
    call Call_000_355e                            ; $3657: $cd $5e $35

Jump_000_365a:
    push hl                                       ; $365a: $e5
    push bc                                       ; $365b: $c5
    call Call_000_356b                            ; $365c: $cd $6b $35
    xor a                                         ; $365f: $af
    ld [hl], a                                    ; $3660: $77
    ld hl, $cc5b                                  ; $3661: $21 $5b $cc
    ld c, $00                                     ; $3664: $0e $00

jr_000_3666:
    ld a, [de]                                    ; $3666: $1a
    ld [hl+], a                                   ; $3667: $22
    inc de                                        ; $3668: $13
    inc c                                         ; $3669: $0c
    cp $ff                                        ; $366a: $fe $ff
    jr nz, jr_000_3666                            ; $366c: $20 $f8

    ld a, c                                       ; $366e: $79
    ld [$cf14], a                                 ; $366f: $ea $14 $cf
    pop bc                                        ; $3672: $c1

Call_000_3673:
    ld hl, $d735                                  ; $3673: $21 $35 $d7
    set 0, [hl]                                   ; $3676: $cb $c6
    pop hl                                        ; $3678: $e1
    xor a                                         ; $3679: $af
    ld [$cd3b], a                                 ; $367a: $ea $3b $cd
    ld [$ccd3], a                                 ; $367d: $ea $d3 $cc
    dec a                                         ; $3680: $3d
    ld [$cd6b], a                                 ; $3681: $ea $6b $cd
    ld [$cd3a], a                                 ; $3684: $ea $3a $cd
    ret                                           ; $3687: $c9


Call_000_3688:
    push hl                                       ; $3688: $e5
    ld hl, $ffe7                                  ; $3689: $21 $e7 $ff
    xor a                                         ; $368c: $af
    ld [hl-], a                                   ; $368d: $32
    ld a, [hl-]                                   ; $368e: $3a
    and a                                         ; $368f: $a7
    jr z, jr_000_369b                             ; $3690: $28 $09

    ld a, [hl+]                                   ; $3692: $2a

jr_000_3693:
    sub [hl]                                      ; $3693: $96
    jr c, jr_000_369b                             ; $3694: $38 $05

    inc hl                                        ; $3696: $23
    inc [hl]                                      ; $3697: $34
    dec hl                                        ; $3698: $2b
    jr jr_000_3693                                ; $3699: $18 $f8

jr_000_369b:
    pop hl                                        ; $369b: $e1
    ret                                           ; $369c: $c9


Call_000_369d:
    ldh a, [rLCDC]                                ; $369d: $f0 $40
    bit 7, a                                      ; $369f: $cb $7f
    jr nz, jr_000_36b1                            ; $36a1: $20 $0e

    ld hl, $5a80                                  ; $36a3: $21 $80 $5a
    ld de, $8800                                  ; $36a6: $11 $00 $88
    ld bc, $0400                                  ; $36a9: $01 $00 $04
    ld a, $04                                     ; $36ac: $3e $04
    jp Jump_000_1828                              ; $36ae: $c3 $28 $18


Call_000_36b1:
jr_000_36b1:
    ld de, $5a80                                  ; $36b1: $11 $80 $5a
    ld hl, $8800                                  ; $36b4: $21 $00 $88
    ld bc, $0480                                  ; $36b7: $01 $80 $04
    jp Jump_000_1883                              ; $36ba: $c3 $83 $18


Call_000_36bd:
Jump_000_36bd:
    ldh a, [rLCDC]                                ; $36bd: $f0 $40
    bit 7, a                                      ; $36bf: $cb $7f
    jr nz, jr_000_36d1                            ; $36c1: $20 $0e

    ld hl, $6298                                  ; $36c3: $21 $98 $62
    ld de, $9600                                  ; $36c6: $11 $00 $96
    ld bc, $0200                                  ; $36c9: $01 $00 $02
    ld a, $04                                     ; $36cc: $3e $04
    jp Jump_000_17f4                              ; $36ce: $c3 $f4 $17


jr_000_36d1:
    ld de, $6298                                  ; $36d1: $11 $98 $62
    ld hl, $9600                                  ; $36d4: $21 $00 $96
    ld bc, $0420                                  ; $36d7: $01 $20 $04
    jp Jump_000_1845                              ; $36da: $c3 $45 $18


Call_000_36dd:
    ldh a, [rLCDC]                                ; $36dd: $f0 $40
    bit 7, a                                      ; $36df: $cb $7f
    jr nz, jr_000_36f1                            ; $36e1: $20 $0e

    ld hl, $5ea0                                  ; $36e3: $21 $a0 $5e
    ld de, $9620                                  ; $36e6: $11 $20 $96
    ld bc, $01e0                                  ; $36e9: $01 $e0 $01
    ld a, $04                                     ; $36ec: $3e $04
    jp Jump_000_17f4                              ; $36ee: $c3 $f4 $17


jr_000_36f1:
    ld de, $5ea0                                  ; $36f1: $11 $a0 $5e
    ld hl, $9620                                  ; $36f4: $21 $20 $96
    ld bc, $041e                                  ; $36f7: $01 $1e $04
    jp Jump_000_1845                              ; $36fa: $c3 $45 $18


Call_000_36fd:
Jump_000_36fd:
    push de                                       ; $36fd: $d5
    ld d, a                                       ; $36fe: $57

jr_000_36ff:
    ld a, d                                       ; $36ff: $7a
    ld [hl+], a                                   ; $3700: $22
    dec bc                                        ; $3701: $0b
    ld a, b                                       ; $3702: $78
    or c                                          ; $3703: $b1
    jr nz, jr_000_36ff                            ; $3704: $20 $f9

    pop de                                        ; $3706: $d1
    ret                                           ; $3707: $c9


Call_000_3708:
    ld hl, $d0b0                                  ; $3708: $21 $b0 $d0
    ld [hl], e                                    ; $370b: $73
    inc hl                                        ; $370c: $23
    ld [hl], d                                    ; $370d: $72
    jp Jump_000_24f9                              ; $370e: $c3 $f9 $24


Call_000_3711:
    ld hl, $c3a0                                  ; $3711: $21 $a0 $c3
    ld de, $cd81                                  ; $3714: $11 $81 $cd
    ld bc, $0168                                  ; $3717: $01 $68 $01
    call Call_000_00b5                            ; $371a: $cd $b5 $00
    ret                                           ; $371d: $c9


Call_000_371e:
Jump_000_371e:
    call Call_000_3726                            ; $371e: $cd $26 $37
    ld a, $01                                     ; $3721: $3e $01
    ldh [$ba], a                                  ; $3723: $e0 $ba
    ret                                           ; $3725: $c9


Call_000_3726:
    xor a                                         ; $3726: $af
    ldh [$ba], a                                  ; $3727: $e0 $ba
    ld hl, $cd81                                  ; $3729: $21 $81 $cd
    ld de, $c3a0                                  ; $372c: $11 $a0 $c3
    ld bc, $0168                                  ; $372f: $01 $68 $01
    call Call_000_00b5                            ; $3732: $cd $b5 $00
    ret                                           ; $3735: $c9


Call_000_3736:
Jump_000_3736:
    ld hl, $c3a0                                  ; $3736: $21 $a0 $c3
    ld de, $c508                                  ; $3739: $11 $08 $c5
    ld bc, $0168                                  ; $373c: $01 $68 $01
    jp Jump_000_00b5                              ; $373f: $c3 $b5 $00


Call_000_3742:
Jump_000_3742:
    xor a                                         ; $3742: $af
    ldh [$ba], a                                  ; $3743: $e0 $ba
    ld hl, $c508                                  ; $3745: $21 $08 $c5
    ld de, $c3a0                                  ; $3748: $11 $a0 $c3
    ld bc, $0168                                  ; $374b: $01 $68 $01
    call Call_000_00b5                            ; $374e: $cd $b5 $00
    ld a, $01                                     ; $3751: $3e $01
    ldh [$ba], a                                  ; $3753: $e0 $ba
    ret                                           ; $3755: $c9


Call_000_3756:
Jump_000_3756:
jr_000_3756:
    call Call_000_20ab                            ; $3756: $cd $ab $20
    dec c                                         ; $3759: $0d
    jr nz, jr_000_3756                            ; $375a: $20 $fa

    ret                                           ; $375c: $c9


Call_000_375d:
Jump_000_375d:
    push af                                       ; $375d: $f5
    call Call_000_3765                            ; $375e: $cd $65 $37
    pop af                                        ; $3761: $f1
    jp Jump_000_23ad                              ; $3762: $c3 $ad $23


Call_000_3765:
Jump_000_3765:
    ld a, [$d088]                                 ; $3765: $fa $88 $d0
    and $80                                       ; $3768: $e6 $80
    ret nz                                        ; $376a: $c0

    push hl                                       ; $376b: $e5

jr_000_376c:
    ld hl, $c02a                                  ; $376c: $21 $2a $c0
    xor a                                         ; $376f: $af
    or [hl]                                       ; $3770: $b6
    inc hl                                        ; $3771: $23
    or [hl]                                       ; $3772: $b6
    inc hl                                        ; $3773: $23
    inc hl                                        ; $3774: $23
    or [hl]                                       ; $3775: $b6
    jr nz, jr_000_376c                            ; $3776: $20 $f4

    pop hl                                        ; $3778: $e1
    ret                                           ; $3779: $c9


    ld e, $42                                     ; $377a: $1e $42
    nop                                           ; $377c: $00
    ld b, b                                       ; $377d: $40
    rrca                                          ; $377e: $0f
    ld c, e                                       ; $377f: $4b
    dec l                                         ; $3780: $2d
    ld b, a                                       ; $3781: $47
    ld a, b                                       ; $3782: $78

Jump_000_3783:
    jp nc, $d9b1                                  ; $3783: $d2 $b1 $d9

    rst $38                                       ; $3786: $ff
    ld e, c                                       ; $3787: $59

Call_000_3788:
    ld a, [$d0ba]                                 ; $3788: $fa $ba $d0
    ld [$d123], a                                 ; $378b: $ea $23 $d1
    cp $c4                                        ; $378e: $fe $c4
    jp nc, Jump_000_3010                          ; $3790: $d2 $10 $30

    ldh a, [$b8]                                  ; $3793: $f0 $b8
    push af                                       ; $3795: $f5
    push hl                                       ; $3796: $e5
    push bc                                       ; $3797: $c5
    push de                                       ; $3798: $d5
    ld a, [$d0bb]                                 ; $3799: $fa $bb $d0
    dec a                                         ; $379c: $3d
    jr nz, jr_000_37aa                            ; $379d: $20 $0b

    call Call_000_2fbb                            ; $379f: $cd $bb $2f
    ld hl, $000b                                  ; $37a2: $21 $0b $00
    add hl, de                                    ; $37a5: $19
    ld e, l                                       ; $37a6: $5d
    ld d, h                                       ; $37a7: $54
    jr jr_000_37ea                                ; $37a8: $18 $40

jr_000_37aa:
    ld a, [$d0bc]                                 ; $37aa: $fa $bc $d0
    ldh [$b8], a                                  ; $37ad: $e0 $b8
    ld [$2000], a                                 ; $37af: $ea $00 $20
    ld a, [$d0bb]                                 ; $37b2: $fa $bb $d0
    dec a                                         ; $37b5: $3d
    add a                                         ; $37b6: $87
    ld d, $00                                     ; $37b7: $16 $00
    ld e, a                                       ; $37b9: $5f
    jr nc, jr_000_37bd                            ; $37ba: $30 $01

    inc d                                         ; $37bc: $14

jr_000_37bd:
    ld hl, $377a                                  ; $37bd: $21 $7a $37
    add hl, de                                    ; $37c0: $19
    ld a, [hl+]                                   ; $37c1: $2a
    ldh [$96], a                                  ; $37c2: $e0 $96
    ld a, [hl]                                    ; $37c4: $7e
    ldh [$95], a                                  ; $37c5: $e0 $95
    ldh a, [$95]                                  ; $37c7: $f0 $95
    ld h, a                                       ; $37c9: $67
    ldh a, [$96]                                  ; $37ca: $f0 $96
    ld l, a                                       ; $37cc: $6f
    ld a, [$d0ba]                                 ; $37cd: $fa $ba $d0
    ld b, a                                       ; $37d0: $47
    ld c, $00                                     ; $37d1: $0e $00

jr_000_37d3:
    ld d, h                                       ; $37d3: $54
    ld e, l                                       ; $37d4: $5d

jr_000_37d5:
    ld a, [hl+]                                   ; $37d5: $2a
    cp $50                                        ; $37d6: $fe $50
    jr nz, jr_000_37d5                            ; $37d8: $20 $fb

    inc c                                         ; $37da: $0c
    ld a, b                                       ; $37db: $78
    cp c                                          ; $37dc: $b9
    jr nz, jr_000_37d3                            ; $37dd: $20 $f4

    ld h, d                                       ; $37df: $62
    ld l, e                                       ; $37e0: $6b
    ld de, $cd6d                                  ; $37e1: $11 $6d $cd
    ld bc, $0014                                  ; $37e4: $01 $14 $00
    call Call_000_00b5                            ; $37e7: $cd $b5 $00

jr_000_37ea:
    ld a, e                                       ; $37ea: $7b
    ld [$cf92], a                                 ; $37eb: $ea $92 $cf
    ld a, d                                       ; $37ee: $7a
    ld [$cf93], a                                 ; $37ef: $ea $93 $cf
    pop de                                        ; $37f2: $d1
    pop bc                                        ; $37f3: $c1
    pop hl                                        ; $37f4: $e1
    pop af                                        ; $37f5: $f1
    ldh [$b8], a                                  ; $37f6: $e0 $b8
    ld [$2000], a                                 ; $37f8: $ea $00 $20
    ret                                           ; $37fb: $c9


Call_000_37fc:
    ldh a, [$b8]                                  ; $37fc: $f0 $b8
    push af                                       ; $37fe: $f5
    ld a, [$cf99]                                 ; $37ff: $fa $99 $cf

Jump_000_3802:
    cp $01                                        ; $3802: $fe $01
    ld a, $01                                     ; $3804: $3e $01
    jr nz, jr_000_380a                            ; $3806: $20 $02

    ld a, $0f                                     ; $3808: $3e $0f

jr_000_380a:
    ldh [$b8], a                                  ; $380a: $e0 $b8
    ld [$2000], a                                 ; $380c: $ea $00 $20
    ld hl, $cf94                                  ; $380f: $21 $94 $cf
    ld a, [hl+]                                   ; $3812: $2a
    ld h, [hl]                                    ; $3813: $66
    ld l, a                                       ; $3814: $6f
    ld a, [$cf96]                                 ; $3815: $fa $96 $cf
    cp $c4                                        ; $3818: $fe $c4
    jr nc, jr_000_382f                            ; $381a: $30 $13

    ld bc, $0003                                  ; $381c: $01 $03 $00

jr_000_381f:
    add hl, bc                                    ; $381f: $09
    dec a                                         ; $3820: $3d

Jump_000_3821:
    jr nz, jr_000_381f                            ; $3821: $20 $fc

    dec hl                                        ; $3823: $2b
    ld a, [hl-]                                   ; $3824: $3a
    ldh [$8d], a                                  ; $3825: $e0 $8d
    ld a, [hl-]                                   ; $3827: $3a
    ldh [$8c], a                                  ; $3828: $e0 $8c
    ld a, [hl]                                    ; $382a: $7e
    ldh [$8b], a                                  ; $382b: $e0 $8b
    jr jr_000_3839                                ; $382d: $18 $0a

Jump_000_382f:
jr_000_382f:
    ld a, $1e                                     ; $382f: $3e $1e
    ldh [$b8], a                                  ; $3831: $e0 $b8
    ld [$2000], a                                 ; $3833: $ea $00 $20
    call $7f86                                    ; $3836: $cd $86 $7f

Jump_000_3839:
jr_000_3839:
    ld de, $ff8b                                  ; $3839: $11 $8b $ff
    pop af                                        ; $383c: $f1
    ldh [$b8], a                                  ; $383d: $e0 $b8
    ld [$2000], a                                 ; $383f: $ea $00 $20
    ret                                           ; $3842: $c9


Call_000_3843:
Jump_000_3843:
    ld hl, $cf50                                  ; $3843: $21 $50 $cf

Call_000_3846:
jr_000_3846:
    ld a, [de]                                    ; $3846: $1a
    inc de                                        ; $3847: $13
    ld [hl+], a                                   ; $3848: $22
    cp $50                                        ; $3849: $fe $50
    jr nz, jr_000_3846                            ; $384b: $20 $f9

    ret                                           ; $384d: $c9


Call_000_384e:
    call Call_000_019a                            ; $384e: $cd $9a $01
    ldh a, [$b7]                                  ; $3851: $f0 $b7
    and a                                         ; $3853: $a7
    ldh a, [$b3]                                  ; $3854: $f0 $b3
    jr z, jr_000_385a                             ; $3856: $28 $02

    ldh a, [$b4]                                  ; $3858: $f0 $b4

jr_000_385a:
    ldh [$b5], a                                  ; $385a: $e0 $b5
    ldh a, [$b3]                                  ; $385c: $f0 $b3
    and a                                         ; $385e: $a7
    jr z, jr_000_3866                             ; $385f: $28 $05

    ld a, $1e                                     ; $3861: $3e $1e

Call_000_3863:
    ldh [$d5], a                                  ; $3863: $e0 $d5
    ret                                           ; $3865: $c9


jr_000_3866:
    ldh a, [$d5]                                  ; $3866: $f0 $d5
    and a                                         ; $3868: $a7
    jr z, jr_000_386f                             ; $3869: $28 $04

    xor a                                         ; $386b: $af
    ldh [$b5], a                                  ; $386c: $e0 $b5
    ret                                           ; $386e: $c9


jr_000_386f:
    ldh a, [$b4]                                  ; $386f: $f0 $b4
    and $03                                       ; $3871: $e6 $03
    jr z, jr_000_387d                             ; $3873: $28 $08

    ldh a, [$b6]                                  ; $3875: $f0 $b6
    and a                                         ; $3877: $a7
    jr nz, jr_000_387d                            ; $3878: $20 $03

    xor a                                         ; $387a: $af
    ldh [$b5], a                                  ; $387b: $e0 $b5

jr_000_387d:
    ld a, $05                                     ; $387d: $3e $05
    ldh [$d5], a                                  ; $387f: $e0 $d5
    ret                                           ; $3881: $c9


Call_000_3882:
Jump_000_3882:
    ldh a, [$8b]                                  ; $3882: $f0 $8b
    push af                                       ; $3884: $f5
    ldh a, [$8c]                                  ; $3885: $f0 $8c
    push af                                       ; $3887: $f5
    xor a                                         ; $3888: $af
    ldh [$8b], a                                  ; $3889: $e0 $8b
    ld a, $06                                     ; $388b: $3e $06
    ldh [$8c], a                                  ; $388d: $e0 $8c

jr_000_388f:
    push hl                                       ; $388f: $e5
    ld a, [$d0a0]                                 ; $3890: $fa $a0 $d0
    and a                                         ; $3893: $a7
    jr z, jr_000_3899                             ; $3894: $28 $03

    call $5697                                    ; $3896: $cd $97 $56

jr_000_3899:
    ld hl, $c4f2                                  ; $3899: $21 $f2 $c4
    call Call_000_3c21                            ; $389c: $cd $21 $3c
    pop hl                                        ; $389f: $e1
    call Call_000_384e                            ; $38a0: $cd $4e $38
    ld a, $2d                                     ; $38a3: $3e $2d
    call Call_000_3e8a                            ; $38a5: $cd $8a $3e
    ldh a, [$b5]                                  ; $38a8: $f0 $b5

Jump_000_38aa:
    and $03                                       ; $38aa: $e6 $03
    jr z, jr_000_388f                             ; $38ac: $28 $e1

Jump_000_38ae:
    pop af                                        ; $38ae: $f1
    ldh [$8c], a                                  ; $38af: $e0 $8c
    pop af                                        ; $38b1: $f1
    ldh [$8b], a                                  ; $38b2: $e0 $8b
    ret                                           ; $38b4: $c9


Call_000_38b5:
    ld a, [$d130]                                 ; $38b5: $fa $30 $d1
    cp $04                                        ; $38b8: $fe $04
    jr z, jr_000_38c4                             ; $38ba: $28 $08

    call Call_000_3882                            ; $38bc: $cd $82 $38
    ld a, $90                                     ; $38bf: $3e $90
    jp Jump_000_23ad                              ; $38c1: $c3 $ad $23


jr_000_38c4:
    ld c, $41                                     ; $38c4: $0e $41

Call_000_38c6:
    jp Jump_000_3756                              ; $38c6: $c3 $56 $37


Call_000_38c9:
Jump_000_38c9:
    push hl                                       ; $38c9: $e5
    push bc                                       ; $38ca: $c5
    ld hl, $7d4d                                  ; $38cb: $21 $4d $7d
    ld b, $0d                                     ; $38ce: $06 $0d
    call Call_000_35f3                            ; $38d0: $cd $f3 $35
    pop bc                                        ; $38d3: $c1
    pop hl                                        ; $38d4: $e1
    ret                                           ; $38d5: $c9


Call_000_38d6:
    push hl                                       ; $38d6: $e5

Jump_000_38d7:
    push de                                       ; $38d7: $d5
    push bc                                       ; $38d8: $c5
    ldh a, [$b8]                                  ; $38d9: $f0 $b8
    push af                                       ; $38db: $f5
    ld a, $0d                                     ; $38dc: $3e $0d
    ldh [$b8], a                                  ; $38de: $e0 $b8
    ld [$2000], a                                 ; $38e0: $ea $00 $20
    call $7db1                                    ; $38e3: $cd $b1 $7d
    pop af                                        ; $38e6: $f1
    ldh [$b8], a                                  ; $38e7: $e0 $b8
    ld [$2000], a                                 ; $38e9: $ea $00 $20
    pop bc                                        ; $38ec: $c1
    pop de                                        ; $38ed: $d1
    pop hl                                        ; $38ee: $e1
    ret                                           ; $38ef: $c9


Call_000_38f0:
Jump_000_38f0:
    ld a, [$d735]                                 ; $38f0: $fa $35 $d7
    bit 6, a                                      ; $38f3: $cb $77
    ret nz                                        ; $38f5: $c0

    ld a, [$d35d]                                 ; $38f6: $fa $5d $d3
    bit 1, a                                      ; $38f9: $cb $4f
    ret z                                         ; $38fb: $c8

Call_000_38fc:
    push hl                                       ; $38fc: $e5
    push de                                       ; $38fd: $d5
    push bc                                       ; $38fe: $c5
    ld a, [$d35d]                                 ; $38ff: $fa $5d $d3
    bit 0, a                                      ; $3902: $cb $47
    jr z, jr_000_390f                             ; $3904: $28 $09

    ld a, [$d35a]                                 ; $3906: $fa $5a $d3
    and $0f                                       ; $3909: $e6 $0f
    ldh [$d5], a                                  ; $390b: $e0 $d5
    jr jr_000_3913                                ; $390d: $18 $04

jr_000_390f:
    ld a, $01                                     ; $390f: $3e $01
    ldh [$d5], a                                  ; $3911: $e0 $d5

jr_000_3913:
    call Call_000_019a                            ; $3913: $cd $9a $01
    ldh a, [$b4]                                  ; $3916: $f0 $b4
    bit 0, a                                      ; $3918: $cb $47
    jr z, jr_000_391e                             ; $391a: $28 $02

    jr jr_000_3922                                ; $391c: $18 $04

jr_000_391e:
    bit 1, a                                      ; $391e: $cb $4f
    jr z, jr_000_3927                             ; $3920: $28 $05

jr_000_3922:
    call Call_000_20ab                            ; $3922: $cd $ab $20
    jr jr_000_392c                                ; $3925: $18 $05

jr_000_3927:
    ldh a, [$d5]                                  ; $3927: $f0 $d5
    and a                                         ; $3929: $a7
    jr nz, jr_000_3913                            ; $392a: $20 $e7

jr_000_392c:
    pop bc                                        ; $392c: $c1
    pop de                                        ; $392d: $d1
    pop hl                                        ; $392e: $e1
    ret                                           ; $392f: $c9


Call_000_3930:
Jump_000_3930:
jr_000_3930:
    ld a, [hl+]                                   ; $3930: $2a
    ld [de], a                                    ; $3931: $12
    inc de                                        ; $3932: $13
    ld a, h                                       ; $3933: $7c
    cp b                                          ; $3934: $b8
    jr nz, jr_000_3930                            ; $3935: $20 $f9

    ld a, l                                       ; $3937: $7d
    cp c                                          ; $3938: $b9
    jr nz, jr_000_3930                            ; $3939: $20 $f5

    ret                                           ; $393b: $c9


Call_000_393c:
    ld hl, $7bd9                                  ; $393c: $21 $d9 $7b
    ld b, $01                                     ; $393f: $06 $01
    jp Jump_000_35f3                              ; $3941: $c3 $f3 $35


Call_000_3944:
    push hl                                       ; $3944: $e5
    push de                                       ; $3945: $d5
    push bc                                       ; $3946: $c5
    ld b, $03                                     ; $3947: $06 $03
    ld hl, $72d5                                  ; $3949: $21 $d5 $72

Jump_000_394c:
    call Call_000_35f3                            ; $394c: $cd $f3 $35
    pop bc                                        ; $394f: $c1
    pop de                                        ; $3950: $d1
    pop hl                                        ; $3951: $e1
    ret                                           ; $3952: $c9


Call_000_3953:
Jump_000_3953:
    ld c, $00                                     ; $3953: $0e $00

jr_000_3955:
    inc c                                         ; $3955: $0c

Jump_000_3956:
    call Call_000_3967                            ; $3956: $cd $67 $39
    ldh a, [$97]                                  ; $3959: $f0 $97
    ld [de], a                                    ; $395b: $12
    inc de                                        ; $395c: $13
    ldh a, [$98]                                  ; $395d: $f0 $98
    ld [de], a                                    ; $395f: $12
    inc de                                        ; $3960: $13
    ld a, c                                       ; $3961: $79
    cp $05                                        ; $3962: $fe $05
    jr nz, jr_000_3955                            ; $3964: $20 $ef

    ret                                           ; $3966: $c9


Call_000_3967:
    push hl                                       ; $3967: $e5
    push de                                       ; $3968: $d5
    push bc                                       ; $3969: $c5
    ld a, b                                       ; $396a: $78
    ld d, a                                       ; $396b: $57
    push hl                                       ; $396c: $e5
    ld hl, $d0bd                                  ; $396d: $21 $bd $d0
    ld b, $00                                     ; $3970: $06 $00
    add hl, bc                                    ; $3972: $09
    ld a, [hl]                                    ; $3973: $7e
    ld e, a                                       ; $3974: $5f
    pop hl                                        ; $3975: $e1
    push hl                                       ; $3976: $e5
    sla c                                         ; $3977: $cb $21
    ld a, d                                       ; $3979: $7a
    and a                                         ; $397a: $a7
    jr z, jr_000_399c                             ; $397b: $28 $1f

    add hl, bc                                    ; $397d: $09

jr_000_397e:
    xor a                                         ; $397e: $af
    ldh [$96], a                                  ; $397f: $e0 $96
    ldh [$97], a                                  ; $3981: $e0 $97
    inc b                                         ; $3983: $04

Call_000_3984:
    ld a, b                                       ; $3984: $78
    cp $ff                                        ; $3985: $fe $ff
    jr z, jr_000_399c                             ; $3987: $28 $13

    ldh [$98], a                                  ; $3989: $e0 $98
    ldh [$99], a                                  ; $398b: $e0 $99
    call Call_000_38c9                            ; $398d: $cd $c9 $38
    ld a, [hl-]                                   ; $3990: $3a
    ld d, a                                       ; $3991: $57
    ldh a, [$98]                                  ; $3992: $f0 $98
    sub d                                         ; $3994: $92
    ld a, [hl+]                                   ; $3995: $2a
    ld d, a                                       ; $3996: $57
    ldh a, [$97]                                  ; $3997: $f0 $97
    sbc d                                         ; $3999: $9a
    jr c, jr_000_397e                             ; $399a: $38 $e2

jr_000_399c:
    srl c                                         ; $399c: $cb $39
    pop hl                                        ; $399e: $e1
    push bc                                       ; $399f: $c5
    ld bc, $000b                                  ; $39a0: $01 $0b $00
    add hl, bc                                    ; $39a3: $09
    pop bc                                        ; $39a4: $c1
    ld a, c                                       ; $39a5: $79

Call_000_39a6:
    cp $02                                        ; $39a6: $fe $02
    jr z, jr_000_39dc                             ; $39a8: $28 $32

    cp $03                                        ; $39aa: $fe $03
    jr z, jr_000_39e3                             ; $39ac: $28 $35

    cp $04                                        ; $39ae: $fe $04
    jr z, jr_000_39e8                             ; $39b0: $28 $36

    cp $05                                        ; $39b2: $fe $05
    jr z, jr_000_39f0                             ; $39b4: $28 $3a

Call_000_39b6:
    push bc                                       ; $39b6: $c5
    ld a, [hl]                                    ; $39b7: $7e

Call_000_39b8:
    swap a                                        ; $39b8: $cb $37
    and $01                                       ; $39ba: $e6 $01
    sla a                                         ; $39bc: $cb $27
    sla a                                         ; $39be: $cb $27
    sla a                                         ; $39c0: $cb $27
    ld b, a                                       ; $39c2: $47
    ld a, [hl+]                                   ; $39c3: $2a
    and $01                                       ; $39c4: $e6 $01
    sla a                                         ; $39c6: $cb $27
    sla a                                         ; $39c8: $cb $27
    add b                                         ; $39ca: $80
    ld b, a                                       ; $39cb: $47
    ld a, [hl]                                    ; $39cc: $7e
    swap a                                        ; $39cd: $cb $37
    and $01                                       ; $39cf: $e6 $01
    sla a                                         ; $39d1: $cb $27
    add b                                         ; $39d3: $80
    ld b, a                                       ; $39d4: $47
    ld a, [hl]                                    ; $39d5: $7e
    and $01                                       ; $39d6: $e6 $01
    add b                                         ; $39d8: $80
    pop bc                                        ; $39d9: $c1
    jr jr_000_39f4                                ; $39da: $18 $18

jr_000_39dc:
    ld a, [hl]                                    ; $39dc: $7e
    swap a                                        ; $39dd: $cb $37
    and $0f                                       ; $39df: $e6 $0f
    jr jr_000_39f4                                ; $39e1: $18 $11

Jump_000_39e3:
jr_000_39e3:
    ld a, [hl]                                    ; $39e3: $7e
    and $0f                                       ; $39e4: $e6 $0f
    jr jr_000_39f4                                ; $39e6: $18 $0c

jr_000_39e8:
    inc hl                                        ; $39e8: $23
    ld a, [hl]                                    ; $39e9: $7e
    swap a                                        ; $39ea: $cb $37
    and $0f                                       ; $39ec: $e6 $0f
    jr jr_000_39f4                                ; $39ee: $18 $04

Jump_000_39f0:
jr_000_39f0:
    inc hl                                        ; $39f0: $23
    ld a, [hl]                                    ; $39f1: $7e
    and $0f                                       ; $39f2: $e6 $0f

jr_000_39f4:
    ld d, $00                                     ; $39f4: $16 $00
    add e                                         ; $39f6: $83
    ld e, a                                       ; $39f7: $5f
    jr nc, jr_000_39fb                            ; $39f8: $30 $01

    inc d                                         ; $39fa: $14

jr_000_39fb:
    sla e                                         ; $39fb: $cb $23
    rl d                                          ; $39fd: $cb $12
    srl b                                         ; $39ff: $cb $38
    srl b                                         ; $3a01: $cb $38
    ld a, b                                       ; $3a03: $78
    add e                                         ; $3a04: $83
    jr nc, jr_000_3a08                            ; $3a05: $30 $01

    inc d                                         ; $3a07: $14

jr_000_3a08:
    ldh [$98], a                                  ; $3a08: $e0 $98
    ld a, d                                       ; $3a0a: $7a
    ldh [$97], a                                  ; $3a0b: $e0 $97
    xor a                                         ; $3a0d: $af
    ldh [$96], a                                  ; $3a0e: $e0 $96
    ld a, [$d12c]                                 ; $3a10: $fa $2c $d1
    ldh [$99], a                                  ; $3a13: $e0 $99
    call Call_000_38c9                            ; $3a15: $cd $c9 $38
    ldh a, [$96]                                  ; $3a18: $f0 $96
    ldh [$95], a                                  ; $3a1a: $e0 $95
    ldh a, [$97]                                  ; $3a1c: $f0 $97
    ldh [$96], a                                  ; $3a1e: $e0 $96
    ldh a, [$98]                                  ; $3a20: $f0 $98
    ldh [$97], a                                  ; $3a22: $e0 $97
    ld a, $64                                     ; $3a24: $3e $64
    ldh [$99], a                                  ; $3a26: $e0 $99
    ld a, $03                                     ; $3a28: $3e $03
    ld b, a                                       ; $3a2a: $47
    call Call_000_38d6                            ; $3a2b: $cd $d6 $38
    ld a, c                                       ; $3a2e: $79
    cp $01                                        ; $3a2f: $fe $01
    ld a, $05                                     ; $3a31: $3e $05
    jr nz, jr_000_3a47                            ; $3a33: $20 $12

    ld a, [$d12c]                                 ; $3a35: $fa $2c $d1
    ld b, a                                       ; $3a38: $47
    ldh a, [$98]                                  ; $3a39: $f0 $98
    add b                                         ; $3a3b: $80
    ldh [$98], a                                  ; $3a3c: $e0 $98
    jr nc, jr_000_3a45                            ; $3a3e: $30 $05

    ldh a, [$97]                                  ; $3a40: $f0 $97
    inc a                                         ; $3a42: $3c
    ldh [$97], a                                  ; $3a43: $e0 $97

jr_000_3a45:
    ld a, $0a                                     ; $3a45: $3e $0a

jr_000_3a47:
    ld b, a                                       ; $3a47: $47
    ldh a, [$98]                                  ; $3a48: $f0 $98
    add b                                         ; $3a4a: $80
    ldh [$98], a                                  ; $3a4b: $e0 $98
    jr nc, jr_000_3a54                            ; $3a4d: $30 $05

    ldh a, [$97]                                  ; $3a4f: $f0 $97
    inc a                                         ; $3a51: $3c
    ldh [$97], a                                  ; $3a52: $e0 $97

Jump_000_3a54:
jr_000_3a54:
    ldh a, [$97]                                  ; $3a54: $f0 $97
    cp $04                                        ; $3a56: $fe $04
    jr nc, jr_000_3a64                            ; $3a58: $30 $0a

    cp $03                                        ; $3a5a: $fe $03
    jr c, jr_000_3a6c                             ; $3a5c: $38 $0e

    ldh a, [$98]                                  ; $3a5e: $f0 $98
    cp $e8                                        ; $3a60: $fe $e8
    jr c, jr_000_3a6c                             ; $3a62: $38 $08

jr_000_3a64:
    ld a, $03                                     ; $3a64: $3e $03
    ldh [$97], a                                  ; $3a66: $e0 $97
    ld a, $e7                                     ; $3a68: $3e $e7
    ldh [$98], a                                  ; $3a6a: $e0 $98

jr_000_3a6c:
    pop bc                                        ; $3a6c: $c1
    pop de                                        ; $3a6d: $d1
    pop hl                                        ; $3a6e: $e1
    ret                                           ; $3a6f: $c9


Call_000_3a70:
    ldh a, [$b8]                                  ; $3a70: $f0 $b8
    push af                                       ; $3a72: $f5
    ld a, $03                                     ; $3a73: $3e $03
    ldh [$b8], a                                  ; $3a75: $e0 $b8
    ld [$2000], a                                 ; $3a77: $ea $00 $20
    call $748d                                    ; $3a7a: $cd $8d $74
    pop bc                                        ; $3a7d: $c1
    ld a, b                                       ; $3a7e: $78
    ldh [$b8], a                                  ; $3a7f: $e0 $b8
    ld [$2000], a                                 ; $3a81: $ea $00 $20
    ret                                           ; $3a84: $c9


Call_000_3a85:
    ldh a, [$b8]                                  ; $3a85: $f0 $b8
    push af                                       ; $3a87: $f5
    ld a, $03                                     ; $3a88: $3e $03

Call_000_3a8a:
    ldh [$b8], a                                  ; $3a8a: $e0 $b8
    ld [$2000], a                                 ; $3a8c: $ea $00 $20

Jump_000_3a8f:
    call $750e                                    ; $3a8f: $cd $0e $75
    pop bc                                        ; $3a92: $c1
    ld a, b                                       ; $3a93: $78
    ldh [$b8], a                                  ; $3a94: $e0 $b8
    ld [$2000], a                                 ; $3a96: $ea $00 $20
    ret                                           ; $3a99: $c9


Call_000_3a9a:
Jump_000_3a9a:
    and a                                         ; $3a9a: $a7
    ret z                                         ; $3a9b: $c8

    ld bc, $000b                                  ; $3a9c: $01 $0b $00

jr_000_3a9f:
    add hl, bc                                    ; $3a9f: $09
    dec a                                         ; $3aa0: $3d
    jr nz, jr_000_3a9f                            ; $3aa1: $20 $fc

    ret                                           ; $3aa3: $c9


Call_000_3aa4:
    and a                                         ; $3aa4: $a7

Call_000_3aa5:
    ret z                                         ; $3aa5: $c8

jr_000_3aa6:
    add hl, bc                                    ; $3aa6: $09
    dec a                                         ; $3aa7: $3d
    jr nz, jr_000_3aa6                            ; $3aa8: $20 $fc

    ret                                           ; $3aaa: $c9


Call_000_3aab:
Jump_000_3aab:
jr_000_3aab:
    ld a, [de]                                    ; $3aab: $1a
    cp [hl]                                       ; $3aac: $be
    ret nz                                        ; $3aad: $c0

    inc de                                        ; $3aae: $13
    inc hl                                        ; $3aaf: $23
    dec c                                         ; $3ab0: $0d
    jr nz, jr_000_3aab                            ; $3ab1: $20 $f8

    ret                                           ; $3ab3: $c9


Call_000_3ab4:
Jump_000_3ab4:
    ld h, $c3                                     ; $3ab4: $26 $c3
    swap a                                        ; $3ab6: $cb $37
    ld l, a                                       ; $3ab8: $6f
    call Call_000_3ad0                            ; $3ab9: $cd $d0 $3a
    push bc                                       ; $3abc: $c5
    ld a, $08                                     ; $3abd: $3e $08
    add c                                         ; $3abf: $81
    ld c, a                                       ; $3ac0: $4f
    call Call_000_3ad0                            ; $3ac1: $cd $d0 $3a
    pop bc                                        ; $3ac4: $c1
    ld a, $08                                     ; $3ac5: $3e $08

Jump_000_3ac7:
    add b                                         ; $3ac7: $80
    ld b, a                                       ; $3ac8: $47
    call Call_000_3ad0                            ; $3ac9: $cd $d0 $3a
    ld a, $08                                     ; $3acc: $3e $08
    add c                                         ; $3ace: $81
    ld c, a                                       ; $3acf: $4f

Call_000_3ad0:
    ld [hl], b                                    ; $3ad0: $70
    inc hl                                        ; $3ad1: $23
    ld [hl], c                                    ; $3ad2: $71
    inc hl                                        ; $3ad3: $23
    ld a, [de]                                    ; $3ad4: $1a
    inc de                                        ; $3ad5: $13
    ld [hl+], a                                   ; $3ad6: $22
    ld a, [de]                                    ; $3ad7: $1a
    inc de                                        ; $3ad8: $13
    ld [hl+], a                                   ; $3ad9: $22
    ret                                           ; $3ada: $c9


Call_000_3adb:
Jump_000_3adb:
    xor a                                         ; $3adb: $af
    ld [$d0a0], a                                 ; $3adc: $ea $a0 $d0

Call_000_3adf:
    ldh a, [$8b]                                  ; $3adf: $f0 $8b
    push af                                       ; $3ae1: $f5
    ldh a, [$8c]                                  ; $3ae2: $f0 $8c
    push af                                       ; $3ae4: $f5
    xor a                                         ; $3ae5: $af
    ldh [$8b], a                                  ; $3ae6: $e0 $8b
    ld a, $06                                     ; $3ae8: $3e $06
    ldh [$8c], a                                  ; $3aea: $e0 $8c

Jump_000_3aec:
    xor a                                         ; $3aec: $af
    ld [$d090], a                                 ; $3aed: $ea $90 $d0
    call Call_000_3b99                            ; $3af0: $cd $99 $3b

Jump_000_3af3:
    call Call_000_3df4                            ; $3af3: $cd $f4 $3d

jr_000_3af6:
    push hl                                       ; $3af6: $e5
    ld a, [$d0a0]                                 ; $3af7: $fa $a0 $d0
    and a                                         ; $3afa: $a7
    jr z, jr_000_3b05                             ; $3afb: $28 $08

    ld b, $1c                                     ; $3afd: $06 $1c
    ld hl, $56d0                                  ; $3aff: $21 $d0 $56
    call Call_000_35f3                            ; $3b02: $cd $f3 $35

jr_000_3b05:
    pop hl                                        ; $3b05: $e1
    call Call_000_384e                            ; $3b06: $cd $4e $38

Jump_000_3b09:
    ldh a, [$b5]                                  ; $3b09: $f0 $b5
    and a                                         ; $3b0b: $a7
    jr nz, jr_000_3b29                            ; $3b0c: $20 $1b

Jump_000_3b0e:
    push hl                                       ; $3b0e: $e5
    ld hl, $c48e                                  ; $3b0f: $21 $8e $c4
    call Call_000_3c21                            ; $3b12: $cd $21 $3c
    pop hl                                        ; $3b15: $e1
    ld a, [$cc34]                                 ; $3b16: $fa $34 $cc
    dec a                                         ; $3b19: $3d
    jr z, jr_000_3b1e                             ; $3b1a: $28 $02

    jr jr_000_3af6                                ; $3b1c: $18 $d8

jr_000_3b1e:
    pop af                                        ; $3b1e: $f1
    ldh [$8c], a                                  ; $3b1f: $e0 $8c
    pop af                                        ; $3b21: $f1
    ldh [$8b], a                                  ; $3b22: $e0 $8b
    xor a                                         ; $3b24: $af

Call_000_3b25:
    ld [$cc4a], a                                 ; $3b25: $ea $4a $cc
    ret                                           ; $3b28: $c9


jr_000_3b29:
    xor a                                         ; $3b29: $af
    ld [$cc4b], a                                 ; $3b2a: $ea $4b $cc
    ldh a, [$b5]                                  ; $3b2d: $f0 $b5
    ld b, a                                       ; $3b2f: $47
    bit 6, a                                      ; $3b30: $cb $77
    jr z, jr_000_3b4e                             ; $3b32: $28 $1a

    ld a, [$cc26]                                 ; $3b34: $fa $26 $cc
    and a                                         ; $3b37: $a7
    jr z, jr_000_3b40                             ; $3b38: $28 $06

    dec a                                         ; $3b3a: $3d
    ld [$cc26], a                                 ; $3b3b: $ea $26 $cc
    jr jr_000_3b69                                ; $3b3e: $18 $29

jr_000_3b40:
    ld a, [$cc4a]                                 ; $3b40: $fa $4a $cc
    and a                                         ; $3b43: $a7
    jr z, jr_000_3b91                             ; $3b44: $28 $4b

    ld a, [$cc28]                                 ; $3b46: $fa $28 $cc
    ld [$cc26], a                                 ; $3b49: $ea $26 $cc
    jr jr_000_3b69                                ; $3b4c: $18 $1b

jr_000_3b4e:
    bit 7, a                                      ; $3b4e: $cb $7f
    jr z, jr_000_3b69                             ; $3b50: $28 $17

    ld a, [$cc26]                                 ; $3b52: $fa $26 $cc

Jump_000_3b55:
    inc a                                         ; $3b55: $3c
    ld c, a                                       ; $3b56: $4f
    ld a, [$cc28]                                 ; $3b57: $fa $28 $cc
    cp c                                          ; $3b5a: $b9
    jr nc, jr_000_3b65                            ; $3b5b: $30 $08

    ld a, [$cc4a]                                 ; $3b5d: $fa $4a $cc
    and a                                         ; $3b60: $a7
    jr z, jr_000_3b91                             ; $3b61: $28 $2e

    ld c, $00                                     ; $3b63: $0e $00

jr_000_3b65:
    ld a, c                                       ; $3b65: $79
    ld [$cc26], a                                 ; $3b66: $ea $26 $cc

jr_000_3b69:
    ld a, [$cc29]                                 ; $3b69: $fa $29 $cc
    and b                                         ; $3b6c: $a0
    jp z, Jump_000_3aec                           ; $3b6d: $ca $ec $3a

jr_000_3b70:
    ldh a, [$b5]                                  ; $3b70: $f0 $b5
    and $03                                       ; $3b72: $e6 $03
    jr z, jr_000_3b84                             ; $3b74: $28 $0e

    push hl                                       ; $3b76: $e5
    ld hl, $cd60                                  ; $3b77: $21 $60 $cd
    bit 5, [hl]                                   ; $3b7a: $cb $6e
    pop hl                                        ; $3b7c: $e1
    jr nz, jr_000_3b84                            ; $3b7d: $20 $05

    ld a, $90                                     ; $3b7f: $3e $90
    call Call_000_23ad                            ; $3b81: $cd $ad $23

Call_000_3b84:
jr_000_3b84:
    pop af                                        ; $3b84: $f1
    ldh [$8c], a                                  ; $3b85: $e0 $8c
    pop af                                        ; $3b87: $f1
    ldh [$8b], a                                  ; $3b88: $e0 $8b
    xor a                                         ; $3b8a: $af
    ld [$cc4a], a                                 ; $3b8b: $ea $4a $cc
    ldh a, [$b5]                                  ; $3b8e: $f0 $b5
    ret                                           ; $3b90: $c9


jr_000_3b91:
    ld a, [$cc37]                                 ; $3b91: $fa $37 $cc
    and a                                         ; $3b94: $a7
    jr z, jr_000_3b69                             ; $3b95: $28 $d2

    jr jr_000_3b70                                ; $3b97: $18 $d7

Call_000_3b99:
    ld a, [$cc24]                                 ; $3b99: $fa $24 $cc
    and a                                         ; $3b9c: $a7
    jr z, jr_000_3ba9                             ; $3b9d: $28 $0a

    ld hl, $c3a0                                  ; $3b9f: $21 $a0 $c3
    ld bc, $0014                                  ; $3ba2: $01 $14 $00

jr_000_3ba5:
    add hl, bc                                    ; $3ba5: $09
    dec a                                         ; $3ba6: $3d
    jr nz, jr_000_3ba5                            ; $3ba7: $20 $fc

jr_000_3ba9:
    ld a, [$cc25]                                 ; $3ba9: $fa $25 $cc
    ld b, $00                                     ; $3bac: $06 $00
    ld c, a                                       ; $3bae: $4f
    add hl, bc                                    ; $3baf: $09
    push hl                                       ; $3bb0: $e5
    ld a, [$cc2a]                                 ; $3bb1: $fa $2a $cc
    and a                                         ; $3bb4: $a7
    jr z, jr_000_3bcb                             ; $3bb5: $28 $14

    push af                                       ; $3bb7: $f5
    ldh a, [$f6]                                  ; $3bb8: $f0 $f6
    bit 1, a                                      ; $3bba: $cb $4f
    jr z, jr_000_3bc3                             ; $3bbc: $28 $05

    ld bc, $0014                                  ; $3bbe: $01 $14 $00
    jr jr_000_3bc6                                ; $3bc1: $18 $03

jr_000_3bc3:
    ld bc, $0028                                  ; $3bc3: $01 $28 $00

jr_000_3bc6:
    pop af                                        ; $3bc6: $f1

jr_000_3bc7:
    add hl, bc                                    ; $3bc7: $09
    dec a                                         ; $3bc8: $3d
    jr nz, jr_000_3bc7                            ; $3bc9: $20 $fc

jr_000_3bcb:
    ld a, [hl]                                    ; $3bcb: $7e
    cp $ed                                        ; $3bcc: $fe $ed
    jr nz, jr_000_3bd4                            ; $3bce: $20 $04

    ld a, [$cc27]                                 ; $3bd0: $fa $27 $cc
    ld [hl], a                                    ; $3bd3: $77

jr_000_3bd4:
    pop hl                                        ; $3bd4: $e1
    ld a, [$cc26]                                 ; $3bd5: $fa $26 $cc
    and a                                         ; $3bd8: $a7
    jr z, jr_000_3bef                             ; $3bd9: $28 $14

    push af                                       ; $3bdb: $f5
    ldh a, [$f6]                                  ; $3bdc: $f0 $f6
    bit 1, a                                      ; $3bde: $cb $4f
    jr z, jr_000_3be7                             ; $3be0: $28 $05

    ld bc, $0014                                  ; $3be2: $01 $14 $00
    jr jr_000_3bea                                ; $3be5: $18 $03

Jump_000_3be7:
jr_000_3be7:
    ld bc, $0028                                  ; $3be7: $01 $28 $00

jr_000_3bea:
    pop af                                        ; $3bea: $f1

jr_000_3beb:
    add hl, bc                                    ; $3beb: $09
    dec a                                         ; $3bec: $3d
    jr nz, jr_000_3beb                            ; $3bed: $20 $fc

jr_000_3bef:
    ld a, [hl]                                    ; $3bef: $7e
    cp $ed                                        ; $3bf0: $fe $ed
    jr z, jr_000_3bf7                             ; $3bf2: $28 $03

    ld [$cc27], a                                 ; $3bf4: $ea $27 $cc

jr_000_3bf7:
    ld a, $ed                                     ; $3bf7: $3e $ed
    ld [hl], a                                    ; $3bf9: $77
    ld a, l                                       ; $3bfa: $7d
    ld [$cc30], a                                 ; $3bfb: $ea $30 $cc
    ld a, h                                       ; $3bfe: $7c
    ld [$cc31], a                                 ; $3bff: $ea $31 $cc
    ld a, [$cc26]                                 ; $3c02: $fa $26 $cc
    ld [$cc2a], a                                 ; $3c05: $ea $2a $cc
    ret                                           ; $3c08: $c9


Call_000_3c09:
    ld b, a                                       ; $3c09: $47
    ld a, [$cc30]                                 ; $3c0a: $fa $30 $cc
    ld l, a                                       ; $3c0d: $6f
    ld a, [$cc31]                                 ; $3c0e: $fa $31 $cc
    ld h, a                                       ; $3c11: $67
    ld [hl], $ec                                  ; $3c12: $36 $ec
    ld a, b                                       ; $3c14: $78
    ret                                           ; $3c15: $c9


Call_000_3c16:
Jump_000_3c16:
    ld a, [$cc30]                                 ; $3c16: $fa $30 $cc
    ld l, a                                       ; $3c19: $6f
    ld a, [$cc31]                                 ; $3c1a: $fa $31 $cc
    ld h, a                                       ; $3c1d: $67
    ld [hl], $7f                                  ; $3c1e: $36 $7f
    ret                                           ; $3c20: $c9


Call_000_3c21:
    ld a, [hl]                                    ; $3c21: $7e
    ld b, a                                       ; $3c22: $47
    ld a, $ee                                     ; $3c23: $3e $ee
    cp b                                          ; $3c25: $b8
    jr nz, jr_000_3c40                            ; $3c26: $20 $18

Jump_000_3c28:
    ldh a, [$8b]                                  ; $3c28: $f0 $8b
    dec a                                         ; $3c2a: $3d
    ldh [$8b], a                                  ; $3c2b: $e0 $8b

Call_000_3c2d:
    ret nz                                        ; $3c2d: $c0

    ldh a, [$8c]                                  ; $3c2e: $f0 $8c

Call_000_3c30:
    dec a                                         ; $3c30: $3d
    ldh [$8c], a                                  ; $3c31: $e0 $8c
    ret nz                                        ; $3c33: $c0

    ld a, $7f                                     ; $3c34: $3e $7f
    ld [hl], a                                    ; $3c36: $77
    ld a, $ff                                     ; $3c37: $3e $ff
    ldh [$8b], a                                  ; $3c39: $e0 $8b
    ld a, $06                                     ; $3c3b: $3e $06
    ldh [$8c], a                                  ; $3c3d: $e0 $8c
    ret                                           ; $3c3f: $c9


jr_000_3c40:
    ldh a, [$8b]                                  ; $3c40: $f0 $8b
    and a                                         ; $3c42: $a7
    ret z                                         ; $3c43: $c8

    dec a                                         ; $3c44: $3d
    ldh [$8b], a                                  ; $3c45: $e0 $8b
    ret nz                                        ; $3c47: $c0

    dec a                                         ; $3c48: $3d
    ldh [$8b], a                                  ; $3c49: $e0 $8b
    ldh a, [$8c]                                  ; $3c4b: $f0 $8c
    dec a                                         ; $3c4d: $3d
    ldh [$8c], a                                  ; $3c4e: $e0 $8c
    ret nz                                        ; $3c50: $c0

    ld a, $06                                     ; $3c51: $3e $06
    ldh [$8c], a                                  ; $3c53: $e0 $8c
    ld a, $ee                                     ; $3c55: $3e $ee
    ld [hl], a                                    ; $3c57: $77
    ret                                           ; $3c58: $c9


Call_000_3c59:
Jump_000_3c59:
    xor a                                         ; $3c59: $af
    jr jr_000_3c5e                                ; $3c5a: $18 $02

Jump_000_3c5c:
    ld a, $01                                     ; $3c5c: $3e $01

jr_000_3c5e:
    ld [$cf11], a                                 ; $3c5e: $ea $11 $cf
    xor a                                         ; $3c61: $af
    ld [$cc3c], a                                 ; $3c62: $ea $3c $cc
    ret                                           ; $3c65: $c9


Call_000_3c66:
Jump_000_3c66:
    push hl                                       ; $3c66: $e5
    ld a, $01                                     ; $3c67: $3e $01

Call_000_3c69:
    ld [$d12a], a                                 ; $3c69: $ea $2a $d1
    call Call_000_3105                            ; $3c6c: $cd $05 $31
    call Call_000_2425                            ; $3c6f: $cd $25 $24
    call Call_000_3df4                            ; $3c72: $cd $f4 $3d
    pop hl                                        ; $3c75: $e1

Call_000_3c76:
    ld bc, $c4b9                                  ; $3c76: $01 $b9 $c4
    jp Jump_000_1b3c                              ; $3c79: $c3 $3c $1b


Call_000_3c7c:
Jump_000_3c7c:
    push bc                                       ; $3c7c: $c5
    xor a                                         ; $3c7d: $af
    ldh [$95], a                                  ; $3c7e: $e0 $95
    ldh [$96], a                                  ; $3c80: $e0 $96
    ldh [$97], a                                  ; $3c82: $e0 $97
    ld a, b                                       ; $3c84: $78
    and $0f                                       ; $3c85: $e6 $0f
    cp $01                                        ; $3c87: $fe $01
    jr z, jr_000_3ca5                             ; $3c89: $28 $1a

    cp $02                                        ; $3c8b: $fe $02
    jr z, jr_000_3c9c                             ; $3c8d: $28 $0d

    ld a, [de]                                    ; $3c8f: $1a
    ldh [$96], a                                  ; $3c90: $e0 $96
    inc de                                        ; $3c92: $13
    ld a, [de]                                    ; $3c93: $1a
    ldh [$97], a                                  ; $3c94: $e0 $97
    inc de                                        ; $3c96: $13
    ld a, [de]                                    ; $3c97: $1a
    ldh [$98], a                                  ; $3c98: $e0 $98
    jr jr_000_3ca8                                ; $3c9a: $18 $0c

jr_000_3c9c:
    ld a, [de]                                    ; $3c9c: $1a
    ldh [$97], a                                  ; $3c9d: $e0 $97
    inc de                                        ; $3c9f: $13
    ld a, [de]                                    ; $3ca0: $1a
    ldh [$98], a                                  ; $3ca1: $e0 $98
    jr jr_000_3ca8                                ; $3ca3: $18 $03

jr_000_3ca5:
    ld a, [de]                                    ; $3ca5: $1a
    ldh [$98], a                                  ; $3ca6: $e0 $98

jr_000_3ca8:
    push de                                       ; $3ca8: $d5
    ld d, b                                       ; $3ca9: $50
    ld a, c                                       ; $3caa: $79
    ld b, a                                       ; $3cab: $47
    xor a                                         ; $3cac: $af
    ld c, a                                       ; $3cad: $4f
    ld a, b                                       ; $3cae: $78
    cp $02                                        ; $3caf: $fe $02
    jr z, jr_000_3d19                             ; $3cb1: $28 $66

    cp $03                                        ; $3cb3: $fe $03
    jr z, jr_000_3d09                             ; $3cb5: $28 $52

    cp $04                                        ; $3cb7: $fe $04
    jr z, jr_000_3cf8                             ; $3cb9: $28 $3d

    cp $05                                        ; $3cbb: $fe $05
    jr z, jr_000_3ce7                             ; $3cbd: $28 $28

    cp $06                                        ; $3cbf: $fe $06
    jr z, jr_000_3cd5                             ; $3cc1: $28 $12

    ld a, $0f                                     ; $3cc3: $3e $0f
    ldh [$99], a                                  ; $3cc5: $e0 $99
    ld a, $42                                     ; $3cc7: $3e $42

Call_000_3cc9:
    ldh [$9a], a                                  ; $3cc9: $e0 $9a
    ld a, $40                                     ; $3ccb: $3e $40
    ldh [$9b], a                                  ; $3ccd: $e0 $9b
    call Call_000_3d42                            ; $3ccf: $cd $42 $3d
    call Call_000_3da6                            ; $3cd2: $cd $a6 $3d

jr_000_3cd5:
    ld a, $01                                     ; $3cd5: $3e $01
    ldh [$99], a                                  ; $3cd7: $e0 $99
    ld a, $86                                     ; $3cd9: $3e $86
    ldh [$9a], a                                  ; $3cdb: $e0 $9a
    ld a, $a0                                     ; $3cdd: $3e $a0
    ldh [$9b], a                                  ; $3cdf: $e0 $9b
    call Call_000_3d42                            ; $3ce1: $cd $42 $3d
    call Call_000_3da6                            ; $3ce4: $cd $a6 $3d

jr_000_3ce7:
    xor a                                         ; $3ce7: $af
    ldh [$99], a                                  ; $3ce8: $e0 $99
    ld a, $27                                     ; $3cea: $3e $27
    ldh [$9a], a                                  ; $3cec: $e0 $9a
    ld a, $10                                     ; $3cee: $3e $10
    ldh [$9b], a                                  ; $3cf0: $e0 $9b
    call Call_000_3d42                            ; $3cf2: $cd $42 $3d
    call Call_000_3da6                            ; $3cf5: $cd $a6 $3d

jr_000_3cf8:
    xor a                                         ; $3cf8: $af
    ldh [$99], a                                  ; $3cf9: $e0 $99
    ld a, $03                                     ; $3cfb: $3e $03
    ldh [$9a], a                                  ; $3cfd: $e0 $9a

Jump_000_3cff:
    ld a, $e8                                     ; $3cff: $3e $e8
    ldh [$9b], a                                  ; $3d01: $e0 $9b
    call Call_000_3d42                            ; $3d03: $cd $42 $3d
    call Call_000_3da6                            ; $3d06: $cd $a6 $3d

jr_000_3d09:
    xor a                                         ; $3d09: $af
    ldh [$99], a                                  ; $3d0a: $e0 $99
    xor a                                         ; $3d0c: $af
    ldh [$9a], a                                  ; $3d0d: $e0 $9a
    ld a, $64                                     ; $3d0f: $3e $64
    ldh [$9b], a                                  ; $3d11: $e0 $9b
    call Call_000_3d42                            ; $3d13: $cd $42 $3d
    call Call_000_3da6                            ; $3d16: $cd $a6 $3d

jr_000_3d19:
    ld c, $00                                     ; $3d19: $0e $00
    ldh a, [$98]                                  ; $3d1b: $f0 $98

jr_000_3d1d:
    cp $0a                                        ; $3d1d: $fe $0a
    jr c, jr_000_3d26                             ; $3d1f: $38 $05

Jump_000_3d21:
    sub $0a                                       ; $3d21: $d6 $0a
    inc c                                         ; $3d23: $0c
    jr jr_000_3d1d                                ; $3d24: $18 $f7

jr_000_3d26:
    ld b, a                                       ; $3d26: $47
    ldh a, [$95]                                  ; $3d27: $f0 $95
    or c                                          ; $3d29: $b1
    ldh [$95], a                                  ; $3d2a: $e0 $95
    jr nz, jr_000_3d33                            ; $3d2c: $20 $05

    call Call_000_3da0                            ; $3d2e: $cd $a0 $3d
    jr jr_000_3d37                                ; $3d31: $18 $04

jr_000_3d33:
    ld a, $f6                                     ; $3d33: $3e $f6
    add c                                         ; $3d35: $81
    ld [hl], a                                    ; $3d36: $77

jr_000_3d37:
    call Call_000_3da6                            ; $3d37: $cd $a6 $3d
    ld a, $f6                                     ; $3d3a: $3e $f6
    add b                                         ; $3d3c: $80
    ld [hl+], a                                   ; $3d3d: $22
    pop de                                        ; $3d3e: $d1
    dec de                                        ; $3d3f: $1b
    pop bc                                        ; $3d40: $c1
    ret                                           ; $3d41: $c9


Call_000_3d42:
    ld c, $00                                     ; $3d42: $0e $00

jr_000_3d44:
    ldh a, [$99]                                  ; $3d44: $f0 $99
    ld b, a                                       ; $3d46: $47
    ldh a, [$96]                                  ; $3d47: $f0 $96
    ldh [$9c], a                                  ; $3d49: $e0 $9c
    cp b                                          ; $3d4b: $b8
    jr c, jr_000_3d94                             ; $3d4c: $38 $46

    sub b                                         ; $3d4e: $90
    ldh [$96], a                                  ; $3d4f: $e0 $96
    ldh a, [$9a]                                  ; $3d51: $f0 $9a
    ld b, a                                       ; $3d53: $47
    ldh a, [$97]                                  ; $3d54: $f0 $97
    ldh [$9d], a                                  ; $3d56: $e0 $9d
    cp b                                          ; $3d58: $b8
    jr nc, jr_000_3d66                            ; $3d59: $30 $0b

    ldh a, [$96]                                  ; $3d5b: $f0 $96
    or $00                                        ; $3d5d: $f6 $00
    jr z, jr_000_3d90                             ; $3d5f: $28 $2f

    dec a                                         ; $3d61: $3d
    ldh [$96], a                                  ; $3d62: $e0 $96
    ldh a, [$97]                                  ; $3d64: $f0 $97

jr_000_3d66:
    sub b                                         ; $3d66: $90
    ldh [$97], a                                  ; $3d67: $e0 $97
    ldh a, [$9b]                                  ; $3d69: $f0 $9b
    ld b, a                                       ; $3d6b: $47
    ldh a, [$98]                                  ; $3d6c: $f0 $98
    ldh [$9e], a                                  ; $3d6e: $e0 $9e
    cp b                                          ; $3d70: $b8
    jr nc, jr_000_3d86                            ; $3d71: $30 $13

    ldh a, [$97]                                  ; $3d73: $f0 $97
    and a                                         ; $3d75: $a7
    jr nz, jr_000_3d81                            ; $3d76: $20 $09

    ldh a, [$96]                                  ; $3d78: $f0 $96
    and a                                         ; $3d7a: $a7
    jr z, jr_000_3d8c                             ; $3d7b: $28 $0f

    dec a                                         ; $3d7d: $3d
    ldh [$96], a                                  ; $3d7e: $e0 $96
    xor a                                         ; $3d80: $af

jr_000_3d81:
    dec a                                         ; $3d81: $3d
    ldh [$97], a                                  ; $3d82: $e0 $97
    ldh a, [$98]                                  ; $3d84: $f0 $98

jr_000_3d86:
    sub b                                         ; $3d86: $90

Jump_000_3d87:
    ldh [$98], a                                  ; $3d87: $e0 $98
    inc c                                         ; $3d89: $0c
    jr jr_000_3d44                                ; $3d8a: $18 $b8

jr_000_3d8c:
    ldh a, [$9d]                                  ; $3d8c: $f0 $9d
    ldh [$97], a                                  ; $3d8e: $e0 $97

jr_000_3d90:
    ldh a, [$9c]                                  ; $3d90: $f0 $9c
    ldh [$96], a                                  ; $3d92: $e0 $96

jr_000_3d94:
    ldh a, [$95]                                  ; $3d94: $f0 $95
    or c                                          ; $3d96: $b1
    jr z, jr_000_3da0                             ; $3d97: $28 $07

    ld a, $f6                                     ; $3d99: $3e $f6
    add c                                         ; $3d9b: $81
    ld [hl], a                                    ; $3d9c: $77
    ldh [$95], a                                  ; $3d9d: $e0 $95
    ret                                           ; $3d9f: $c9


Call_000_3da0:
jr_000_3da0:
    bit 7, d                                      ; $3da0: $cb $7a
    ret z                                         ; $3da2: $c8

    ld [hl], $f6                                  ; $3da3: $36 $f6
    ret                                           ; $3da5: $c9


Call_000_3da6:
    bit 7, d                                      ; $3da6: $cb $7a
    jr nz, jr_000_3db2                            ; $3da8: $20 $08

Jump_000_3daa:
    bit 6, d                                      ; $3daa: $cb $72
    jr z, jr_000_3db2                             ; $3dac: $28 $04

    ldh a, [$95]                                  ; $3dae: $f0 $95
    and a                                         ; $3db0: $a7
    ret z                                         ; $3db1: $c8

jr_000_3db2:
    inc hl                                        ; $3db2: $23
    ret                                           ; $3db3: $c9


Call_000_3db4:
Jump_000_3db4:
    push hl                                       ; $3db4: $e5
    push de                                       ; $3db5: $d5
    push bc                                       ; $3db6: $c5
    add a                                         ; $3db7: $87
    ld d, $00                                     ; $3db8: $16 $00
    ld e, a                                       ; $3dba: $5f
    add hl, de                                    ; $3dbb: $19
    ld a, [hl+]                                   ; $3dbc: $2a
    ld h, [hl]                                    ; $3dbd: $66
    ld l, a                                       ; $3dbe: $6f
    ld de, $3dc4                                  ; $3dbf: $11 $c4 $3d
    push de                                       ; $3dc2: $d5
    jp hl                                         ; $3dc3: $e9


    pop bc                                        ; $3dc4: $c1
    pop de                                        ; $3dc5: $d1
    pop hl                                        ; $3dc6: $e1
    ret                                           ; $3dc7: $c9


Call_000_3dc8:
Jump_000_3dc8:
    ld b, $00                                     ; $3dc8: $06 $00

Call_000_3dca:
    ld c, a                                       ; $3dca: $4f

jr_000_3dcb:
    ld a, [hl]                                    ; $3dcb: $7e
    cp $ff                                        ; $3dcc: $fe $ff
    jr z, jr_000_3dd7                             ; $3dce: $28 $07

    cp c                                          ; $3dd0: $b9

Call_000_3dd1:
    jr z, jr_000_3dd9                             ; $3dd1: $28 $06

    inc b                                         ; $3dd3: $04
    add hl, de                                    ; $3dd4: $19
    jr jr_000_3dcb                                ; $3dd5: $18 $f4

jr_000_3dd7:
    and a                                         ; $3dd7: $a7
    ret                                           ; $3dd8: $c9


jr_000_3dd9:
    scf                                           ; $3dd9: $37
    ret                                           ; $3dda: $c9


Call_000_3ddb:
    call Call_000_0082                            ; $3ddb: $cd $82 $00
    ld a, $01                                     ; $3dde: $3e $01
    ld [$cfd0], a                                 ; $3de0: $ea $d0 $cf
    call Call_000_3e25                            ; $3de3: $cd $25 $3e
    call Call_000_371e                            ; $3de6: $cd $1e $37
    call Call_000_36bd                            ; $3de9: $cd $bd $36
    call Call_000_3e0a                            ; $3dec: $cd $0a $3e
    jr jr_000_3df4                                ; $3def: $18 $03

Call_000_3df1:
    call Call_000_3e02                            ; $3df1: $cd $02 $3e

Call_000_3df4:
Jump_000_3df4:
jr_000_3df4:
    ld c, $03                                     ; $3df4: $0e $03
    jp Jump_000_3756                              ; $3df6: $c3 $56 $37


Call_000_3df9:
Jump_000_3df9:
    ld a, $e4                                     ; $3df9: $3e $e4
    ldh [rBGP], a                                 ; $3dfb: $e0 $47
    ld a, $d0                                     ; $3dfd: $3e $d0
    ldh [rOBP0], a                                ; $3dff: $e0 $48
    ret                                           ; $3e01: $c9


Call_000_3e02:
Jump_000_3e02:
    xor a                                         ; $3e02: $af
    ldh [rBGP], a                                 ; $3e03: $e0 $47
    ldh [rOBP0], a                                ; $3e05: $e0 $48
    ldh [rOBP1], a                                ; $3e07: $e0 $49
    ret                                           ; $3e09: $c9


Call_000_3e0a:
Jump_000_3e0a:
    ld b, $ff                                     ; $3e0a: $06 $ff

Call_000_3e0c:
Jump_000_3e0c:
    ld a, [$cf20]                                 ; $3e0c: $fa $20 $cf
    and a                                         ; $3e0f: $a7
    ret z                                         ; $3e10: $c8

    ld a, $45                                     ; $3e11: $3e $45
    jp Jump_000_3e8a                              ; $3e13: $c3 $8a $3e


Call_000_3e16:
    ld a, e                                       ; $3e16: $7b
    cp $1b                                        ; $3e17: $fe $1b
    ld d, $00                                     ; $3e19: $16 $00
    jr nc, jr_000_3e23                            ; $3e1b: $30 $06

    cp $0a                                        ; $3e1d: $fe $0a
    inc d                                         ; $3e1f: $14
    jr nc, jr_000_3e23                            ; $3e20: $30 $01

    inc d                                         ; $3e22: $14

jr_000_3e23:
    ld [hl], d                                    ; $3e23: $72
    ret                                           ; $3e24: $c9


Call_000_3e25:
    ld hl, $cfc9                                  ; $3e25: $21 $c9 $cf
    ld a, [hl]                                    ; $3e28: $7e
    push af                                       ; $3e29: $f5
    res 0, [hl]                                   ; $3e2a: $cb $86
    push hl                                       ; $3e2c: $e5
    xor a                                         ; $3e2d: $af
    ld [$d3ad], a                                 ; $3e2e: $ea $ad $d3
    call Call_000_0061                            ; $3e31: $cd $61 $00
    ld b, $05                                     ; $3e34: $06 $05
    ld hl, $785b                                  ; $3e36: $21 $5b $78
    call Call_000_35f3                            ; $3e39: $cd $f3 $35
    call Call_000_007b                            ; $3e3c: $cd $7b $00
    pop hl                                        ; $3e3f: $e1
    pop af                                        ; $3e40: $f1
    ld [hl], a                                    ; $3e41: $77
    call Call_000_0997                            ; $3e42: $cd $97 $09
    call Call_000_369d                            ; $3e45: $cd $9d $36
    jp Jump_000_2425                              ; $3e48: $c3 $25 $24


Call_000_3e4b:
    ld a, b                                       ; $3e4b: $78
    ld [$d123], a                                 ; $3e4c: $ea $23 $d1
    ld [$cf96], a                                 ; $3e4f: $ea $96 $cf
    ld a, c                                       ; $3e52: $79
    ld [$cf9b], a                                 ; $3e53: $ea $9b $cf
    ld hl, $d322                                  ; $3e56: $21 $22 $d3
    call Call_000_2be5                            ; $3e59: $cd $e5 $2b
    ret nc                                        ; $3e5c: $d0

    call Call_000_2fec                            ; $3e5d: $cd $ec $2f
    call Call_000_3843                            ; $3e60: $cd $43 $38
    scf                                           ; $3e63: $37
    ret                                           ; $3e64: $c9


Call_000_3e65:
    ld a, b                                       ; $3e65: $78
    ld [$cf96], a                                 ; $3e66: $ea $96 $cf
    ld a, c                                       ; $3e69: $79
    ld [$d12c], a                                 ; $3e6a: $ea $2c $d1
    xor a                                         ; $3e6d: $af
    ld [$cc49], a                                 ; $3e6e: $ea $49 $cc
    ld b, $13                                     ; $3e71: $06 $13
    ld hl, $7da5                                  ; $3e73: $21 $a5 $7d
    jp Jump_000_35f3                              ; $3e76: $c3 $f3 $35


Call_000_3e79:
Jump_000_3e79:
    push hl                                       ; $3e79: $e5

Call_000_3e7a:
    push de                                       ; $3e7a: $d5
    push bc                                       ; $3e7b: $c5
    ld b, $04                                     ; $3e7c: $06 $04
    ld hl, $7aa0                                  ; $3e7e: $21 $a0 $7a
    call Call_000_35f3                            ; $3e81: $cd $f3 $35
    ldh a, [$d3]                                  ; $3e84: $f0 $d3
    pop bc                                        ; $3e86: $c1
    pop de                                        ; $3e87: $d1
    pop hl                                        ; $3e88: $e1
    ret                                           ; $3e89: $c9


Call_000_3e8a:
Jump_000_3e8a:
    ld [$cc4e], a                                 ; $3e8a: $ea $4e $cc
    ldh a, [$b8]                                  ; $3e8d: $f0 $b8
    ld [$cf17], a                                 ; $3e8f: $ea $17 $cf
    push af                                       ; $3e92: $f5
    ld a, $13                                     ; $3e93: $3e $13
    ldh [$b8], a                                  ; $3e95: $e0 $b8
    ld [$2000], a                                 ; $3e97: $ea $00 $20
    call $7e49                                    ; $3e9a: $cd $49 $7e

Jump_000_3e9d:
    ld a, [$d0bc]                                 ; $3e9d: $fa $bc $d0
    ldh [$b8], a                                  ; $3ea0: $e0 $b8
    ld [$2000], a                                 ; $3ea2: $ea $00 $20
    ld de, $3eaa                                  ; $3ea5: $11 $aa $3e
    push de                                       ; $3ea8: $d5
    jp hl                                         ; $3ea9: $e9


    pop af                                        ; $3eaa: $f1
    ldh [$b8], a                                  ; $3eab: $e0 $b8
    ld [$2000], a                                 ; $3ead: $ea $00 $20
    ret                                           ; $3eb0: $c9


Call_000_3eb1:
    ld a, [$cc4f]                                 ; $3eb1: $fa $4f $cc
    ld h, a                                       ; $3eb4: $67
    ld a, [$cc50]                                 ; $3eb5: $fa $50 $cc
    ld l, a                                       ; $3eb8: $6f
    ld a, [$cc51]                                 ; $3eb9: $fa $51 $cc
    ld d, a                                       ; $3ebc: $57
    ld a, [$cc52]                                 ; $3ebd: $fa $52 $cc
    ld e, a                                       ; $3ec0: $5f
    ld a, [$cc53]                                 ; $3ec1: $fa $53 $cc
    ld b, a                                       ; $3ec4: $47
    ld a, [$cc54]                                 ; $3ec5: $fa $54 $cc
    ld c, a                                       ; $3ec8: $4f
    ret                                           ; $3ec9: $c9


Call_000_3eca:
    ld b, $07                                     ; $3eca: $06 $07
    ld hl, $6b0d                                  ; $3ecc: $21 $0d $6b
    jp Jump_000_35f3                              ; $3ecf: $c3 $f3 $35


Call_000_3ed2:
    ldh a, [$b8]                                  ; $3ed2: $f0 $b8
    push af                                       ; $3ed4: $f5
    ldh a, [$b4]                                  ; $3ed5: $f0 $b4
    bit 0, a                                      ; $3ed7: $cb $47
    jr z, jr_000_3f07                             ; $3ed9: $28 $2c

    ld a, $11                                     ; $3edb: $3e $11
    ld [$2000], a                                 ; $3edd: $ea $00 $20
    ldh [$b8], a                                  ; $3ee0: $e0 $b8
    call $69a0                                    ; $3ee2: $cd $a0 $69
    ldh a, [$ee]                                  ; $3ee5: $f0 $ee
    and a                                         ; $3ee7: $a7
    jr nz, jr_000_3efa                            ; $3ee8: $20 $10

Call_000_3eea:
    ld a, [$cd3e]                                 ; $3eea: $fa $3e $cd
    ld [$2000], a                                 ; $3eed: $ea $00 $20
    ldh [$b8], a                                  ; $3ef0: $e0 $b8
    ld de, $3ef7                                  ; $3ef2: $11 $f7 $3e
    push de                                       ; $3ef5: $d5
    jp hl                                         ; $3ef6: $e9


    xor a                                         ; $3ef7: $af
    jr jr_000_3f09                                ; $3ef8: $18 $0f

jr_000_3efa:
    ld b, $03                                     ; $3efa: $06 $03
    ld hl, $7b40                                  ; $3efc: $21 $40 $7b
    call Call_000_35f3                            ; $3eff: $cd $f3 $35
    ldh a, [$db]                                  ; $3f02: $f0 $db
    and a                                         ; $3f04: $a7
    jr z, jr_000_3f09                             ; $3f05: $28 $02

jr_000_3f07:
    ld a, $ff                                     ; $3f07: $3e $ff

jr_000_3f09:
    ldh [$eb], a                                  ; $3f09: $e0 $eb
    pop af                                        ; $3f0b: $f1
    ld [$2000], a                                 ; $3f0c: $ea $00 $20
    ldh [$b8], a                                  ; $3f0f: $e0 $b8
    ret                                           ; $3f11: $c9


Call_000_3f12:
Jump_000_3f12:
    ldh [$8c], a                                  ; $3f12: $e0 $8c
    ld hl, $3f3f                                  ; $3f14: $21 $3f $3f
    call Call_000_3f2c                            ; $3f17: $cd $2c $3f
    ld hl, $cf16                                  ; $3f1a: $21 $16 $cf
    set 0, [hl]                                   ; $3f1d: $cb $c6
    call Call_000_291c                            ; $3f1f: $cd $1c $29

Call_000_3f22:
    ld hl, $d371                                  ; $3f22: $21 $71 $d3
    ldh a, [$ec]                                  ; $3f25: $f0 $ec
    ld [hl+], a                                   ; $3f27: $22
    ldh a, [$ed]                                  ; $3f28: $f0 $ed
    ld [hl], a                                    ; $3f2a: $77
    ret                                           ; $3f2b: $c9


Call_000_3f2c:
    ld a, [$d371]                                 ; $3f2c: $fa $71 $d3
    ldh [$ec], a                                  ; $3f2f: $e0 $ec
    ld a, [$d372]                                 ; $3f31: $fa $72 $d3
    ldh [$ed], a                                  ; $3f34: $e0 $ed
    ld a, l                                       ; $3f36: $7d
    ld [$d371], a                                 ; $3f37: $ea $71 $d3
    ld a, h                                       ; $3f3a: $7c
    ld [$d372], a                                 ; $3f3b: $ea $72 $d3
    ret                                           ; $3f3e: $c9


    pop af                                        ; $3f3f: $f1
    ld h, [hl]                                    ; $3f40: $66
    ei                                            ; $3f41: $fb
    ld h, [hl]                                    ; $3f42: $66
    add d                                         ; $3f43: $82
    ld e, e                                       ; $3f44: $5b
    ld [hl], l                                    ; $3f45: $75
    ld e, e                                       ; $3f46: $5b
    ld h, e                                       ; $3f47: $63
    ld l, c                                       ; $3f48: $69
    add c                                         ; $3f49: $81
    ld l, c                                       ; $3f4a: $69
    add [hl]                                      ; $3f4b: $86
    ld l, c                                       ; $3f4c: $69
    cp l                                          ; $3f4d: $bd
    ld l, h                                       ; $3f4e: $6c
    or d                                          ; $3f4f: $b2
    ld e, e                                       ; $3f50: $5b
    sbc h                                         ; $3f51: $9c
    ld e, e                                       ; $3f52: $5b
    ret z                                         ; $3f53: $c8

Call_000_3f54:
    ld e, e                                       ; $3f54: $5b
    ld d, e                                       ; $3f55: $53
    ld h, h                                       ; $3f56: $64
    ld e, b                                       ; $3f57: $58
    ld h, h                                       ; $3f58: $64
    ld de, $a365                                  ; $3f59: $11 $65 $a3
    ld h, h                                       ; $3f5c: $64
    xor b                                         ; $3f5d: $a8
    ld h, h                                       ; $3f5e: $64
    xor l                                         ; $3f5f: $ad
    ld h, h                                       ; $3f60: $64

Jump_000_3f61:
    or d                                          ; $3f61: $b2
    ld h, h                                       ; $3f62: $64
    ret nc                                        ; $3f63: $d0

    ld h, h                                       ; $3f64: $64
    push de                                       ; $3f65: $d5
    ld h, h                                       ; $3f66: $64
    ld [bc], a                                    ; $3f67: $02
    ld h, l                                       ; $3f68: $65
    jp c, $df64                                   ; $3f69: $da $64 $df

    ld h, h                                       ; $3f6c: $64
    db $e4                                        ; $3f6d: $e4
    ld h, h                                       ; $3f6e: $64
    or a                                          ; $3f6f: $b7
    ld h, h                                       ; $3f70: $64
    cp h                                          ; $3f71: $bc
    ld h, h                                       ; $3f72: $64
    pop bc                                        ; $3f73: $c1
    ld h, h                                       ; $3f74: $64
    add $64                                       ; $3f75: $c6 $64
    bit 4, h                                      ; $3f77: $cb $64
    ld [$2965], sp                                ; $3f79: $08 $65 $29
    ld h, l                                       ; $3f7c: $65
    xor a                                         ; $3f7d: $af
    ld l, c                                       ; $3f7e: $69
    db $dd                                        ; $3f7f: $dd
    ld e, h                                       ; $3f80: $5c
    ld h, a                                       ; $3f81: $67
    ld e, b                                       ; $3f82: $58
    ld a, d                                       ; $3f83: $7a
    ld e, b                                       ; $3f84: $58
    sbc l                                         ; $3f85: $9d
    ld h, a                                       ; $3f86: $67
    sub $67                                       ; $3f87: $d6 $67
    push hl                                       ; $3f89: $e5
    ld e, l                                       ; $3f8a: $5d
    ld b, d                                       ; $3f8b: $42
    ld l, d                                       ; $3f8c: $6a
    add l                                         ; $3f8d: $85
    ld a, [hl]                                    ; $3f8e: $7e
    adc d                                         ; $3f8f: $8a
    ld a, [hl]                                    ; $3f90: $7e
    adc a                                         ; $3f91: $8f
    ld a, [hl]                                    ; $3f92: $7e
    adc c                                         ; $3f93: $89
    ld l, b                                       ; $3f94: $68
    adc a                                         ; $3f95: $8f
    ld l, b                                       ; $3f96: $68
    ldh [rOCPD], a                                ; $3f97: $e0 $6b
    push hl                                       ; $3f99: $e5
    ld l, e                                       ; $3f9a: $6b
    ld [$6c6c], sp                                ; $3f9b: $08 $6c $6c
    ld l, e                                       ; $3f9e: $6b
    jr z, @+$6c                                   ; $3f9f: $28 $6a

    scf                                           ; $3fa1: $37
    ld a, a                                       ; $3fa2: $7f
    ld [hl-], a                                   ; $3fa3: $32
    ld a, a                                       ; $3fa4: $7f
    dec e                                         ; $3fa5: $1d
    ld e, h                                       ; $3fa6: $5c
    xor c                                         ; $3fa7: $a9
    ld l, c                                       ; $3fa8: $69
    cpl                                           ; $3fa9: $2f
    ld l, d                                       ; $3faa: $6a
    dec d                                         ; $3fab: $15
    ld l, d                                       ; $3fac: $6a
    ld [hl+], a                                   ; $3fad: $22
    ld l, d                                       ; $3fae: $6a
    ld d, [hl]                                    ; $3faf: $56

Call_000_3fb0:
Jump_000_3fb0:
    ld l, c                                       ; $3fb0: $69
    xor a                                         ; $3fb1: $af
    ld a, e                                       ; $3fb2: $7b
    or [hl]                                       ; $3fb3: $b6
    ld e, [hl]                                    ; $3fb4: $5e
    ret                                           ; $3fb5: $c9


Jump_000_3fb6:
    ld e, [hl]                                    ; $3fb6: $5e

Call_000_3fb7:
    db $dd                                        ; $3fb7: $dd
    ld e, [hl]                                    ; $3fb8: $5e
    ldh a, [$5e]                                  ; $3fb9: $f0 $5e
    ld [bc], a                                    ; $3fbb: $02
    ld a, h                                       ; $3fbc: $7c
    ret c                                         ; $3fbd: $d8

    ld a, e                                       ; $3fbe: $7b
    db $fd                                        ; $3fbf: $fd
    ld a, e                                       ; $3fc0: $7b
    dec [hl]                                      ; $3fc1: $35
    ld a, h                                       ; $3fc2: $7c
    nop                                           ; $3fc3: $00
    nop                                           ; $3fc4: $00

Jump_000_3fc5:
    nop                                           ; $3fc5: $00
    nop                                           ; $3fc6: $00
    nop                                           ; $3fc7: $00
    nop                                           ; $3fc8: $00
    nop                                           ; $3fc9: $00
    nop                                           ; $3fca: $00
    nop                                           ; $3fcb: $00

Call_000_3fcc:
    nop                                           ; $3fcc: $00
    nop                                           ; $3fcd: $00
    nop                                           ; $3fce: $00
    nop                                           ; $3fcf: $00
    nop                                           ; $3fd0: $00
    nop                                           ; $3fd1: $00
    nop                                           ; $3fd2: $00
    nop                                           ; $3fd3: $00
    nop                                           ; $3fd4: $00
    nop                                           ; $3fd5: $00
    nop                                           ; $3fd6: $00
    nop                                           ; $3fd7: $00
    nop                                           ; $3fd8: $00
    nop                                           ; $3fd9: $00
    nop                                           ; $3fda: $00
    nop                                           ; $3fdb: $00
    nop                                           ; $3fdc: $00
    nop                                           ; $3fdd: $00
    nop                                           ; $3fde: $00
    nop                                           ; $3fdf: $00
    nop                                           ; $3fe0: $00
    nop                                           ; $3fe1: $00
    nop                                           ; $3fe2: $00
    nop                                           ; $3fe3: $00
    nop                                           ; $3fe4: $00

Jump_000_3fe5:
    nop                                           ; $3fe5: $00
    nop                                           ; $3fe6: $00
    nop                                           ; $3fe7: $00

Jump_000_3fe8:
    nop                                           ; $3fe8: $00
    nop                                           ; $3fe9: $00

Jump_000_3fea:
    nop                                           ; $3fea: $00
    nop                                           ; $3feb: $00
    nop                                           ; $3fec: $00
    nop                                           ; $3fed: $00
    nop                                           ; $3fee: $00
    nop                                           ; $3fef: $00
    nop                                           ; $3ff0: $00
    nop                                           ; $3ff1: $00
    nop                                           ; $3ff2: $00
    nop                                           ; $3ff3: $00
    nop                                           ; $3ff4: $00
    nop                                           ; $3ff5: $00
    nop                                           ; $3ff6: $00
    nop                                           ; $3ff7: $00

Call_000_3ff8:
    nop                                           ; $3ff8: $00
    nop                                           ; $3ff9: $00
    nop                                           ; $3ffa: $00
    nop                                           ; $3ffb: $00
    nop                                           ; $3ffc: $00

Call_000_3ffd:
    nop                                           ; $3ffd: $00
    nop                                           ; $3ffe: $00
    nop                                           ; $3fff: $00
