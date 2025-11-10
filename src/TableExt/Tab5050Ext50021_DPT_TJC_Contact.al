tableextension 50021 Contact extends Contact
{
    // 1. 23/6/2014 DP.AYD
    //    -Add Keys : NRIC No.
    // 2. 23/6/2014 DP.AYD
    //    -Remark NRIC Validate

    fields
    {
        field(50000; Birthday; Date)
        {
            Description = 'DP';

            trigger OnValidate()
            begin
                Age := DATE2DMY(TODAY, 3) - DATE2DMY(Birthday, 3);   //for Patient use
            end;
        }
        field(50001; Gender; Option)
        {
            Description = 'DP';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(50002; Age; Integer)
        {
            Description = 'DP';
        }
        field(50003; Occupation; Text[50])
        {
            Description = 'DP';
        }
        field(50004; "Marital Status"; Option)
        {
            Description = 'DP';
            OptionCaption = 'Single,Married,Widow';
            OptionMembers = Single,Married,Widow;
        }
        field(50005; "Home Phone No."; Text[30])
        {
            Description = 'DP';
        }
        field(50006; "Chinese Name"; Text[10])
        {
            Description = 'DP';
        }
        field(50007; "NRIC No."; Code[20])
        {
            Description = 'DP';

            trigger OnValidate()
            var
            //     fPatientCard: Page "50010";
            //     fContactList: Page "5052";
            //     ContactExist: Boolean;
            //     PatientCardExist: Boolean;
            //     ContNo: Code[20];
            begin
                //duplicated NRIC Check - For Patient
                /*
                //TJCSG1.00 #1 Start
                IF "NRIC No." ='' THEN
                  EXIT;
                
                Cont.RESET;
                Cont.SETFILTER("No.",'<>%1', "No.");
                Cont.SETRANGE("NRIC No.", "NRIC No.");
                IF Cont.FINDSET THEN   BEGIN
                  ContactExist := TRUE;
                  ContNo:= Cont."No.";
                END;
                
                PatientCard.RESET;
                PatientCard.SETRANGE("Contact No.", ContNo);
                IF PatientCard.FINDSET THEN
                  PatientCardExist := TRUE;
                
                IF ContactExist AND PatientCardExist THEN BEGIN    //show Patient Card
                  MESSAGE(Text051,"NRIC No.");
                  IF CONFIRM(Text052) THEN BEGIN
                    fPatientCard.SetHeader(Cont,FALSE);
                    fPatientCard.SetEdit(FALSE);
                
                    fPatientCard.RUNMODAL;
                    CLEAR(fPatientCard);
                
                  END;
                  CLEAR("NRIC No.");
                END;
                
                IF ContactExist AND (NOT PatientCardExist) THEN BEGIN   //Show Contact List
                  MESSAGE(Text050, "NRIC No.");
                  IF CONFIRM(Text053) THEN BEGIN
                    fContactList.SETTABLEVIEW(Cont);
                    fContactList.RUN;
                  END;
                  CLEAR("NRIC No.");
                END;
                //TJCSG1.00 #1 End
                */

            end;
        }
        field(50008; "Location Code"; Code[10])
        {
            Description = 'DP';
            TableRelation = Location;
        }
    }
}

