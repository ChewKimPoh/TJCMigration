table 50003 "Patient Checkup Info"
{
    // TJCSG1.00 Upgrade
    //  1. 03/04/2014 DP.JL DD#85
    //     - change method on finding user.
    //  2. 26/06/2014 DP.AYD DD#166
    //     - set "Visit Date" Field Editable = No
    //     - set "Doctor Code" Field Editable = No
    //     - set "Doctor Name" Field Editable = No
    //  3. 04/07/2014 dp.dst DD #178
    //     - Added new field:
    //       - 50000  Status  Boolean
    //         Has the options: Open,Closed.
    //         If the Status is Closed, users shall not be able to delete or edit the records.
    //  4. 07/07/2014 DP.AYD
    //     - Change Caption Fields :
    //       Low blood pressure => Diastolic Pressure šµ³•©‰
    //       High blood pressure => Systolic Pressure š³›ã©‰
    //  5. 06/08/2014 dp.dst
    //     TJC DD #209: issue For "Tongue 1", when you select Entry No. 25, system will change to Entry No 4.
    //     - Cannot find the root cause, as it does not happen to other field selection. It may be caused by the sorting mechanism in SQL, as the table
    //       uses 2 keys, that are Entry No. + Name. As the system needs to pick up the Tongue1.Name only, it returns the first occurence that was found
    //       for that name.
    //     - Inserted codes on "Tongue 1 - OnLookup".
    //     - Made the changes on "Tongue 2" as well as there is possibility that it may happen to "Tongue 2".


    fields
    {
        field(10; "Contact No."; Code[20])
        {
            NotBlank = true;
        }
        field(20; "History No."; Integer)
        {
            NotBlank = true;
        }
        field(30; "Visit Date"; Date)
        {
            Editable = false;
        }
        field(40; "Doctor code"; Code[20])
        {
            Editable = false;
            TableRelation = User;

            trigger OnValidate()
            var
                rUser: Record User;
                rUserSetup: Record "User Setup";
            begin
                /*START TJCSG1.00 #1*/
                rUser.SETRANGE("User Name", "Doctor code");
                IF rUser.FINDFIRST THEN
                    "Doctor Name" := rUser."Full Name";
                //IF rUser.GET("Doctor code") THEN
                //  "Doctor Name" := rUser.Name;
                /*END TJCSG1.00 #1*/

                IF rUserSetup.GET("Doctor code") THEN
                    "Location Code" := rUserSetup."Location Code";

            end;
        }
        field(50; "Doctor Name"; Text[30])
        {
            Editable = false;
        }
        field(55; "Location Code"; Code[10])
        {
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(60; Tongue1; Text[30])
        {
            TableRelation = "Tongue 1".Name;
        }
        field(70; Tongue2; Text[30])
        {
            TableRelation = "Tongue 2".Name;
        }
        field(80; "Left Pulse"; Text[30])
        {
            TableRelation = Pulse.Name;
        }
        field(85; "Right Pulse"; Text[30])
        {
            TableRelation = Pulse.Name;
        }
        field(110; "Low Blood Pressure"; Integer)
        {
            Caption = 'Diastolic Pressure šµ³•©‰';
        }
        field(120; "High Blood Pressure"; Integer)
        {
            Caption = 'Systolic Pressure š³›ã©‰';
        }
        field(124; "Category No."; Integer)
        {
            BlankZero = true;
            NotBlank = true;
            TableRelation = "Sickness Category".EntryNo;

            trigger OnValidate()
            begin
                CALCFIELDS(Category);
                VALIDATE("Sickness No.", 0);
                VALIDATE("Type No.", 0);
            end;
        }
        field(125; Category; Text[10])
        {
            CalcFormula = Lookup("Sickness Category".Name WHERE(EntryNo = FIELD("Category No.")));
            FieldClass = FlowField;
        }
        field(128; "Sickness No."; Integer)
        {
            BlankZero = true;
            NotBlank = true;
            TableRelation = Sickness."Sickness EntryNo" WHERE("Category EntryNo" = FIELD("Category No."));

            trigger OnValidate()
            begin
                CALCFIELDS(Sickness);
                VALIDATE("Type No.", 0);
            end;
        }
        field(130; Sickness; Text[50])
        {
            CalcFormula = Lookup(Sickness."Sickness Name" WHERE("Category EntryNo" = FIELD("Category No."),
                                                                 "Sickness EntryNo" = FIELD("Sickness No.")));
            FieldClass = FlowField;
        }
        field(135; "Type No."; Integer)
        {
            BlankZero = true;
            NotBlank = true;
            TableRelation = "Sickness Type"."Type EntryNo" WHERE("Category EntryNo" = FIELD("Category No."),
                                                                  "Sickness EntryNo" = FIELD("Sickness No."));

            trigger OnValidate()
            begin
                CALCFIELDS(Sickness, Type);
            end;
        }
        field(140; Type; Text[80])
        {
            CalcFormula = Lookup("Sickness Type"."Type Name" WHERE("Category EntryNo" = FIELD("Category No."),
                                                                    "Sickness EntryNo" = FIELD("Sickness No."),
                                                                    "Type EntryNo" = FIELD("Type No.")));
            FieldClass = FlowField;
        }
        field(150; "Diagnosis Info"; Text[250])
        {
        }
        field(50000; Status; Option)
        {
            OptionMembers = Open,Closed;
        }
    }

    keys
    {
        key(Key1; "Contact No.", "History No.")
        {
        }
        key(Key2; "Visit Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tongue1)
        {
        }
    }

    trigger OnDelete()
    begin
        IF CONFIRM(Text001) THEN BEGIN
            Prescription.SETRANGE("Contact No.", "Contact No.");
            Prescription.SETRANGE("History No.", "History No.");
            IF Prescription.FINDFIRST THEN
                Prescription.DELETEALL;
        END;
    end;

    var
        Prescription: Record "50004";
        Text001: Label 'Do you really want to delete this Patient Card?';
        EditCheckupForm: Page "50083";
        rPatientCheckup: Record "50003";
        SalesSetup: Record "311";
        Text010: Label 'PatientNo/NRIC/ EnglishName cannot be empty!';
        Text002: Label 'Do you want to create a new Patient Card?';
        Text003: Label 'Contact No with  NRIC %1 has already existed! ';
        Text004: Label 'Patient card with NRIC %1 has already existed! ';
        Text005: Label 'Do you want to use the existing Patient Card?';
        Text006: Label 'Do you want to use the existing empty patient Card with this NRIC?';
        Text007: Label 'A new patient card cannot be created in View status.';
        Text008: Label 'Cannot edit previous record!';
        Text009: Label 'No history record exists. Please click new!';

    procedure ValidatePatient(): Boolean
    var
        pContact: Record "5050";
    begin
        pContact.SETRANGE("No.", "Contact No.");

        IF pContact.FIND('-') THEN
            IF (pContact."No." = '') OR (pContact."NRIC No." = '') OR (pContact.Name = '') THEN
                ERROR(Text010);

        EXIT(TRUE);
    end;

    procedure ViewAction()
    begin
        IF ValidatePatient THEN BEGIN
            rPatientCheckup.SETRANGE("Contact No.", "Contact No.");
            rPatientCheckup.SETRANGE("History No.", "History No.");
            EditCheckupForm.SETTABLEVIEW(rPatientCheckup);
            //EditCheckupForm.SetEdit(FALSE);
            EditCheckupForm.EDITABLE(FALSE);
            EditCheckupForm.RUNMODAL;
            CLEAR(EditCheckupForm);
        END;
    end;

    procedure EditAction()
    begin
        IF ValidatePatient THEN BEGIN

            rPatientCheckup.RESET;
            rPatientCheckup.SETRANGE("Contact No.", "Contact No.");
            rPatientCheckup.SETRANGE("History No.", "History No.");
            IF NOT rPatientCheckup.FINDSET THEN
                ERROR(Text009);

            SalesSetup.GET;
            IF NOT SalesSetup."Allow Edit" THEN BEGIN
                IF TODAY > "Visit Date" THEN
                    ERROR(Text008);
            END;

            rPatientCheckup.RESET;
            rPatientCheckup.SETRANGE("Contact No.", "Contact No.");
            rPatientCheckup.SETRANGE("History No.", "History No.");

            EditCheckupForm.SETTABLEVIEW(rPatientCheckup);

            EditCheckupForm.RUNMODAL;
            CLEAR(EditCheckupForm);
        END;
    end;

    procedure NewAction()
    var
        CheckupInfo: Record "50003";
        NextLineNo: Integer;
        NewCheckupForm: Page "50083";
    begin
        IF ValidatePatient THEN BEGIN

            CheckupInfo.SETRANGE("Contact No.", "Contact No.");
            IF CheckupInfo.FINDLAST THEN
                NextLineNo := CheckupInfo."History No."
            ELSE
                NextLineNo := 0;

            //CLEAR(NewCheckupForm);
            //NewCheckupForm.SetNew("Contact No.", NextLineNo);

            CheckupInfo.INIT;
            CheckupInfo."Contact No." := "Contact No.";
            CheckupInfo."History No." := NextLineNo + 1;
            CheckupInfo."Visit Date" := TODAY;
            CheckupInfo.VALIDATE("Doctor code", USERID);
            CheckupInfo.INSERT;
            PAGE.RUN(PAGE::"Check Up Card", CheckupInfo);
        END;
    end;
}

