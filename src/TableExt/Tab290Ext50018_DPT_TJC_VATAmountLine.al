// table 290 "VAT Amount Line"
// {
//     // TJCSG1.00
//     // 1. 24/07/2014 DP.CC
//     //    - Change Text Constants: VAT to GST.

//     Caption = 'VAT Amount Line';

//     fields
//     {
//         field(1;"VAT %";Decimal)
//         {
//             Caption = 'VAT %';
//             DecimalPlaces = 0:5;
//             Editable = false;
//         }
//         field(2;"VAT Base";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'VAT Base';
//             Editable = false;
//         }
//         field(3;"VAT Amount";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'VAT Amount';

//             trigger OnValidate()
//             begin
//                 TESTFIELD("VAT %");
//                 TESTFIELD("VAT Base");
//                 IF "VAT Amount" / "VAT Base" < 0 THEN
//                   ERROR(Text002,FIELDCAPTION("VAT Amount"));
//                 "VAT Difference" := "VAT Amount" - "Calculated VAT Amount";
//             end;
//         }
//         field(4;"Amount Including VAT";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Amount Including VAT';
//             Editable = false;
//         }
//         field(5;"VAT Identifier";Code[10])
//         {
//             Caption = 'VAT Identifier';
//             Editable = false;
//         }
//         field(6;"Line Amount";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Line Amount';
//             Editable = false;
//         }
//         field(7;"Inv. Disc. Base Amount";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Inv. Disc. Base Amount';
//             Editable = false;
//         }
//         field(8;"Invoice Discount Amount";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Invoice Discount Amount';

//             trigger OnValidate()
//             begin
//                 TESTFIELD("Inv. Disc. Base Amount");
//                 IF "Invoice Discount Amount" / "Inv. Disc. Base Amount" > 1 THEN
//                   ERROR(
//                     InvoiceDiscAmtIsGreaterThanBaseAmtErr,
//                     FIELDCAPTION("Invoice Discount Amount"),"Inv. Disc. Base Amount");
//                 "VAT Base" := "Line Amount" - "Invoice Discount Amount";
//             end;
//         }
//         field(9;"VAT Calculation Type";Option)
//         {
//             Caption = 'VAT Calculation Type';
//             Editable = false;
//             OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
//             OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
//         }
//         field(10;"Tax Group Code";Code[10])
//         {
//             Caption = 'Tax Group Code';
//             Editable = false;
//             TableRelation = "Tax Group";
//         }
//         field(11;Quantity;Decimal)
//         {
//             Caption = 'Quantity';
//             DecimalPlaces = 0:5;
//             Editable = false;
//         }
//         field(12;Modified;Boolean)
//         {
//             Caption = 'Modified';
//         }
//         field(13;"Use Tax";Boolean)
//         {
//             Caption = 'Use Tax';
//         }
//         field(14;"Calculated VAT Amount";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'Calculated VAT Amount';
//             Editable = false;
//         }
//         field(15;"VAT Difference";Decimal)
//         {
//             AutoFormatType = 1;
//             Caption = 'VAT Difference';
//             Editable = false;
//         }
//         field(16;Positive;Boolean)
//         {
//             Caption = 'Positive';
//         }
//         field(17;"Includes Prepayment";Boolean)
//         {
//             Caption = 'Includes Prepayment';
//         }
//         field(18;"VAT Clause Code";Code[10])
//         {
//             Caption = 'VAT Clause Code';
//             TableRelation = "VAT Clause";
//         }
//     }

//     keys
//     {
//         key(Key1;"VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",Positive)
//         {
//         }
//     }

//     fieldgroups
//     {
//     }

//     var
//         Text000: Label '%1% GST';
//         Text001: Label 'GST Amount';
//         Text002: Label '%1 must not be negative.';
//         InvoiceDiscAmtIsGreaterThanBaseAmtErr: Label 'The maximum %1 that you can apply is %2.', Comment='1 Invoice Discount Amount that should be set 2 Maximum Amount that you can assign';
//         Text004: Label '%1 for %2 must not exceed %3 = %4.';
//         Currency: Record "4";
//         AllowVATDifference: Boolean;
//         PricesIncludingVAT: Boolean;
//         GlobalsInitialized: Boolean;
//         Text005: Label '%1 must not exceed %2 = %3.';

//     procedure CheckVATDifference(NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean;NewPricesIncludingVAT: Boolean)
//     var
//         GLSetup: Record "98";
//     begin
//         InitGlobals(NewCurrencyCode,NewAllowVATDifference,NewPricesIncludingVAT);
//         IF NOT AllowVATDifference THEN
//           TESTFIELD("VAT Difference",0);
//         IF ABS("VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
//           IF NewCurrencyCode <> '' THEN
//             ERROR(
//               Text004,FIELDCAPTION("VAT Difference"),Currency.Code,
//               Currency.FIELDCAPTION("Max. VAT Difference Allowed"),Currency."Max. VAT Difference Allowed")
//           ELSE BEGIN
//             IF GLSetup.GET THEN;
//             IF ABS("VAT Difference") > GLSetup."Max. VAT Difference Allowed" THEN
//               ERROR(
//                 Text005,FIELDCAPTION("VAT Difference"),
//                 GLSetup.FIELDCAPTION("Max. VAT Difference Allowed"),GLSetup."Max. VAT Difference Allowed");
//           END;
//     end;

//     local procedure InitGlobals(NewCurrencyCode: Code[10];NewAllowVATDifference: Boolean;NewPricesIncludingVAT: Boolean)
//     begin
//         SetCurrency(NewCurrencyCode);
//         AllowVATDifference := NewAllowVATDifference;
//         PricesIncludingVAT := NewPricesIncludingVAT;
//         GlobalsInitialized := TRUE;
//     end;

//     local procedure SetCurrency(CurrencyCode: Code[10])
//     begin
//         IF CurrencyCode = '' THEN
//           Currency.InitRoundingPrecision
//         ELSE
//           Currency.GET(CurrencyCode);
//     end;

//     procedure InsertLine()
//     var
//         VATAmountLine: Record "290";
//     begin
//         IF ("VAT Base" <> 0) OR ("Amount Including VAT" <> 0) THEN BEGIN
//           Positive := "Line Amount" >= 0;
//           VATAmountLine := Rec;
//           IF FIND THEN BEGIN
//             "Line Amount" := "Line Amount" + VATAmountLine."Line Amount";
//             "Inv. Disc. Base Amount" := "Inv. Disc. Base Amount" + VATAmountLine."Inv. Disc. Base Amount";
//             "Invoice Discount Amount" := "Invoice Discount Amount" + VATAmountLine."Invoice Discount Amount";
//             Quantity := Quantity + VATAmountLine.Quantity;
//             "VAT Base" := "VAT Base" + VATAmountLine."VAT Base";
//             "Amount Including VAT" := "Amount Including VAT" + VATAmountLine."Amount Including VAT";
//             "VAT Difference" := "VAT Difference" + VATAmountLine."VAT Difference";
//             "VAT Amount" := "Amount Including VAT" - "VAT Base";
//             "Calculated VAT Amount" := "Calculated VAT Amount" + VATAmountLine."Calculated VAT Amount";
//             MODIFY;
//           END ELSE BEGIN
//             "VAT Amount" := "Amount Including VAT" - "VAT Base";
//             INSERT;
//           END;
//         END;
//     end;

//     procedure GetLine(Number: Integer)
//     begin
//         IF Number = 1 THEN
//           FIND('-')
//         ELSE
//           NEXT;
//     end;

//     procedure VATAmountText(): Text[30]
//     begin
//         IF FIND('-') THEN
//           IF NEXT = 0 THEN
//             IF "VAT %" <> 0 THEN
//               EXIT(STRSUBSTNO(Text000,"VAT %"));
//         EXIT(Text001);
//     end;

//     procedure CopyFrom(var FromVATAmountLine: Record "290")
//     begin
//         DELETEALL;
//         IF FromVATAmountLine.FIND('-') THEN
//           REPEAT
//             Rec := FromVATAmountLine;
//             INSERT;
//           UNTIL FromVATAmountLine.NEXT = 0;
//     end;

//     procedure GetTotalLineAmount(SubtractVAT: Boolean;CurrencyCode: Code[10]): Decimal
//     var
//         LineAmount: Decimal;
//     begin
//         IF SubtractVAT THEN
//           SetCurrency(CurrencyCode);

//         LineAmount := 0;

//         IF FIND('-') THEN
//           REPEAT
//             IF SubtractVAT THEN
//               LineAmount :=
//                 LineAmount + ROUND("Line Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
//             ELSE
//               LineAmount := LineAmount + "Line Amount";
//           UNTIL NEXT = 0;

//         EXIT(LineAmount);
//     end;

//     procedure GetTotalVATAmount(): Decimal
//     var
//         VATAmount: Decimal;
//     begin
//         VATAmount := 0;
//         IF FIND('-') THEN
//           REPEAT
//             VATAmount := VATAmount + "VAT Amount";
//           UNTIL NEXT = 0;
//         EXIT(VATAmount);
//     end;

//     procedure GetTotalInvDiscAmount(): Decimal
//     var
//         InvDiscAmount: Decimal;
//     begin
//         InvDiscAmount := 0;
//         IF FIND('-') THEN
//           REPEAT
//             InvDiscAmount := InvDiscAmount + "Invoice Discount Amount";
//           UNTIL NEXT = 0;
//         EXIT(InvDiscAmount);
//     end;

//     procedure GetTotalInvDiscBaseAmount(SubtractVAT: Boolean;CurrencyCode: Code[10]): Decimal
//     var
//         InvDiscBaseAmount: Decimal;
//     begin
//         IF SubtractVAT THEN
//           SetCurrency(CurrencyCode);

//         InvDiscBaseAmount := 0;

//         IF FIND('-') THEN
//           REPEAT
//             IF SubtractVAT THEN
//               InvDiscBaseAmount :=
//                 InvDiscBaseAmount +
//                 ROUND("Inv. Disc. Base Amount" / (1 + "VAT %" / 100),Currency."Amount Rounding Precision")
//             ELSE
//               InvDiscBaseAmount := InvDiscBaseAmount + "Inv. Disc. Base Amount";
//           UNTIL NEXT = 0;
//         EXIT(InvDiscBaseAmount);
//     end;

//     procedure GetTotalVATBase(): Decimal
//     var
//         VATBase: Decimal;
//     begin
//         VATBase := 0;

//         IF FIND('-') THEN
//           REPEAT
//             VATBase := VATBase + "VAT Base";
//           UNTIL NEXT = 0;
//         EXIT(VATBase);
//     end;

//     procedure GetTotalAmountInclVAT(): Decimal
//     var
//         AmountInclVAT: Decimal;
//     begin
//         AmountInclVAT := 0;

//         IF FIND('-') THEN
//           REPEAT
//             AmountInclVAT := AmountInclVAT + "Amount Including VAT";
//           UNTIL NEXT = 0;
//         EXIT(AmountInclVAT);
//     end;

//     procedure GetTotalVATDiscount(CurrencyCode: Code[10];NewPricesIncludingVAT: Boolean): Decimal
//     var
//         VATDiscount: Decimal;
//     begin
//         SetCurrency(CurrencyCode);

//         VATDiscount := 0;

//         IF FIND('-') THEN
//           REPEAT
//             IF NewPricesIncludingVAT THEN
//               VATDiscount :=
//                 VATDiscount +
//                 ROUND(
//                   ("Line Amount" - "Invoice Discount Amount") * "VAT %" / (100 + "VAT %"),
//                   Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
//                 "VAT Amount" + "VAT Difference"
//             ELSE
//               VATDiscount :=
//                 VATDiscount +
//                 ROUND(
//                   "VAT Base" * "VAT %" / 100,
//                   Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
//                 "VAT Amount";
//           UNTIL NEXT = 0;
//         EXIT(VATDiscount);
//     end;

//     procedure GetAnyLineModified(): Boolean
//     begin
//         IF FIND('-') THEN
//           REPEAT
//             IF Modified THEN
//               EXIT(TRUE);
//           UNTIL NEXT = 0;
//         EXIT(FALSE);
//     end;

//     procedure SetInvoiceDiscountAmount(NewInvoiceDiscount: Decimal;NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal)
//     var
//         TotalInvDiscBaseAmount: Decimal;
//         NewRemainder: Decimal;
//     begin
//         InitGlobals(NewCurrencyCode,FALSE,NewPricesIncludingVAT);
//         TotalInvDiscBaseAmount := GetTotalInvDiscBaseAmount(FALSE,Currency.Code);
//         IF TotalInvDiscBaseAmount = 0 THEN
//           EXIT;
//         FIND('-');
//         REPEAT
//           IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
//             IF TotalInvDiscBaseAmount = 0 THEN
//               NewRemainder := 0
//             ELSE
//               NewRemainder :=
//                 NewRemainder + NewInvoiceDiscount * "Inv. Disc. Base Amount" / TotalInvDiscBaseAmount;
//             IF "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") THEN BEGIN
//               VALIDATE(
//                 "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
//               CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
//               Modified := TRUE;
//               MODIFY;
//             END;
//             NewRemainder := NewRemainder - "Invoice Discount Amount";
//           END;
//         UNTIL NEXT = 0;
//     end;

//     procedure SetInvoiceDiscountPercent(NewInvoiceDiscountPct: Decimal;NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;CalcInvDiscPerVATID: Boolean;NewVATBaseDiscPct: Decimal)
//     var
//         NewRemainder: Decimal;
//     begin
//         InitGlobals(NewCurrencyCode,FALSE,NewPricesIncludingVAT);
//         IF FIND('-') THEN
//           REPEAT
//             IF "Inv. Disc. Base Amount" <> 0 THEN BEGIN
//               NewRemainder :=
//                 NewRemainder + NewInvoiceDiscountPct * "Inv. Disc. Base Amount" / 100;
//               IF "Invoice Discount Amount" <> ROUND(NewRemainder,Currency."Amount Rounding Precision") THEN BEGIN
//                 VALIDATE(
//                   "Invoice Discount Amount",ROUND(NewRemainder,Currency."Amount Rounding Precision"));
//                 CalcVATFields(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);
//                 "VAT Difference" := 0;
//                 Modified := TRUE;
//                 MODIFY;
//               END;
//               IF CalcInvDiscPerVATID THEN
//                 NewRemainder := 0
//               ELSE
//                 NewRemainder := NewRemainder - "Invoice Discount Amount";
//             END;
//           UNTIL NEXT = 0;
//     end;

//     local procedure GetCalculatedVAT(NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal): Decimal
//     begin
//         IF NOT GlobalsInitialized THEN
//           InitGlobals(NewCurrencyCode,FALSE,NewPricesIncludingVAT);

//         IF NewPricesIncludingVAT THEN
//           EXIT(
//             ROUND(
//               ("Line Amount" - "Invoice Discount Amount") * "VAT %" / (100 + "VAT %") * (1 - NewVATBaseDiscPct / 100),
//               Currency."Amount Rounding Precision",Currency.VATRoundingDirection));

//         EXIT(
//           ROUND(
//             ("Line Amount" - "Invoice Discount Amount") * "VAT %" / 100 * (1 - NewVATBaseDiscPct / 100),
//             Currency."Amount Rounding Precision",Currency.VATRoundingDirection));
//     end;

//     procedure CalcVATFields(NewCurrencyCode: Code[10];NewPricesIncludingVAT: Boolean;NewVATBaseDiscPct: Decimal)
//     begin
//         IF NOT GlobalsInitialized THEN
//           InitGlobals(NewCurrencyCode,FALSE,NewPricesIncludingVAT);

//         "VAT Amount" := GetCalculatedVAT(NewCurrencyCode,NewPricesIncludingVAT,NewVATBaseDiscPct);

//         IF NewPricesIncludingVAT THEN BEGIN
//           IF NewVATBaseDiscPct = 0 THEN BEGIN
//             "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
//             "VAT Base" := "Amount Including VAT" - "VAT Amount";
//           END ELSE BEGIN
//             "VAT Base" :=
//               ROUND(
//                 ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
//                 Currency."Amount Rounding Precision");
//             "Amount Including VAT" := "VAT Base" + "VAT Amount";
//           END;
//         END ELSE BEGIN
//           "VAT Base" := "Line Amount" - "Invoice Discount Amount";
//           "Amount Including VAT" := "VAT Base" + "VAT Amount";
//         END;
//         "Calculated VAT Amount" := "VAT Amount";
//         "VAT Difference" := 0;
//         Modified := TRUE;
//     end;

//     local procedure CalcValueLCY(Value: Decimal;PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal): Decimal
//     var
//         CurrencyExchangeRate: Record "330";
//     begin
//         EXIT(CurrencyExchangeRate.ExchangeAmtFCYToLCY(PostingDate,CurrencyCode,Value,CurrencyFactor));
//     end;

//     procedure GetBaseLCY(PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal): Decimal
//     begin
//         EXIT(ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
//     end;

//     procedure GetAmountLCY(PostingDate: Date;CurrencyCode: Code[10];CurrencyFactor: Decimal): Decimal
//     begin
//         EXIT(
//           ROUND(CalcValueLCY("Amount Including VAT",PostingDate,CurrencyCode,CurrencyFactor)) -
//           ROUND(CalcValueLCY("VAT Base",PostingDate,CurrencyCode,CurrencyFactor)));
//     end;
// }

