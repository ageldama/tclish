<a name="srctitlemd_25FF126ED55098F5A3ADE90FC9604473"></a>
# tclish

> Much more Lispy(tm) Tcl/Tk 9.0

* VERSION: 0.0.1

* Currenctly only tested under:
   * SBCL 2.6.4 / Linux x86_64
   * libtcl9.0 (9.0.1+dfsg-2)
   * libtk9.0 (9.0.1-3)

* Suggestions, Patches, Issues and PRs are Welcomed.

...More hacks will be come, anytime soon. ;-)
<a name="toc_6994206AA5146E62315E61B6ECF6F56B"></a>
# Table of Contents

   1. [tclish](#srctitlemd_25FF126ED55098F5A3ADE90FC9604473)
   1. [Table of Contents](#toc_6994206AA5146E62315E61B6ECF6F56B)
   1. [Introduction](#srcintromd_1F1968DB82DBDB250C1C2FC9B7B5E3E2)
   1. [Examples](#srcexamplesmd_AA62A0DF0FC45CCB3A15A661B4D674EA)
   1. [Dependencies](#srcgetting-startedmd_A75A5DAA4F7310D9E1BEBC2021F72C16)
   1. [Supporting](#srcsupportmd_E54E17F75D771528488BEBED6C50185B)
   1. [License](#srclicensemd_59C292C7659785E1BB31D2B4B69534CC)
   1. [APIs](#api-refs_523EACBA8CE3897B5EE91337B062B676)
      1. [PACKAGE: `TCLISH/CFFI`](#api-package-tclishcffi_2A3BE0C95DB163CCF774EAC0DD1B4C4D)
         1. [CFFI-FUNCTION: `C-MEMCPY`](#api-cffi-function-c-memcpy_5AD0A0B62AB3FCE5F82DE4C864909DA0)
         1. [CFFI-FUNCTION: `C-MEMSET`](#api-cffi-function-c-memset_645F8593538721721F184ADD6490BF4E)
         1. [CFFI-FUNCTION: `C-STRLEN`](#api-cffi-function-c-strlen_F2E4A72F57AE9F2B599FFA74765D0F73)
         1. [FUNCTION: `C-MEMCPY`](#api-function-c-memcpy_405995BF3B003D5CD4B5B90C5F5ECE3B)
         1. [FUNCTION: `C-MEMSET`](#api-function-c-memset_849BD33172C68D6D43DA423994A633DB)
         1. [FUNCTION: `C-PTR-ARRAY-TO-PTR-LIST`](#api-function-c-ptr-array-to-ptr-list_3C88A5EEB9F82313779A475997659444)
         1. [FUNCTION: `C-STRING-ARRAY-TO-STRING-LIST`](#api-function-c-string-array-to-string-list_9C2C3F5DCCFA93E2D7E796CF26E4088D)
         1. [FUNCTION: `C-STRLEN`](#api-function-c-strlen_CA150F3ABD68C9E7E1B61B41321D4C9E)
         1. [FUNCTION: `CFFI/ALLOC+BZERO`](#api-function-cffiallocbzero_13C2896536E0DB3C3F8E856DA35F5C99)
         1. [MACRO: `C-MEMSET*`](#api-macro-c-memset_08252D1E6FCD6DF0646685A623517990)
         1. [MACRO: `MEM-ZERO`](#api-macro-mem-zero_69B96029A4FB94A49F3425F4B8C5D2D6)
      1. [PACKAGE: `TCLISH/REDIR-TO-OUTSTREAM-CHAN`](#api-package-tclishredir-to-outstream-chan_8F0BB6607E03DE2AC1AC5F88B42DAE56)
         1. [CFFI-TYPE: `CHAN-INSTANCE-COUNTER-T`](#api-cffi-type-chan-instance-counter-t_11484592A01B49C0726E6017A6835377)
         1. [CLASS: `<REDIR-TO-OUTSTREAM-CHAN>`](#api-class-redir-to-outstream-chan_8A128B3D278B2F76A50D20900C27D146)
         1. [FUNCTION: `%NEW-INSTANCE-COUNTER`](#api-function-new-instance-counter_0C03A6CF8CAF5BBC870337325D5ED628)
         1. [FUNCTION: `%PUT-INSTANCE`](#api-function-put-instance_5B0073A3ED3D68F0A54F5D28078D72BC)
         1. [FUNCTION: `%REM-INSTANCE`](#api-function-rem-instance_221D543AC3F2A2BFF3EA9F03213E6C32)
         1. [METHOD: `DEALLOC` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>))`](#api-method-dealloc-chan-redir-to-outstream-chan_842F4377BF4B24449CE7AB0EE1B511CD)
         1. [METHOD: `REGIST` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>) &KEY TCL-INTERP-PTR TCL-STD-CHAN-TYPE)`](#api-method-regist-chan-redir-to-outstream-chan-key-tcl-interp-ptr-tcl-std-chan-type_0134F346B807C4B11A4D52F97B0204FD)
         1. [METHOD: `UNREGIST` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>) &KEY TCL-INTERP-PTR)`](#api-method-unregist-chan-redir-to-outstream-chan-key-tcl-interp-ptr_EAB1788FF7D662A3A7FE6C8D21383397)
         1. [VARIABLE: `*CHAN-INSTANCE-COUNTER*`](#api-variable-chan-instance-counter_FB4018494A1840EA60EAA0E5BC717DEC)
         1. [VARIABLE: `*LOCK*`](#api-variable-lock_382D682E7780D1D4397903094E17A83B)
         1. [VARIABLE: `*REGISTERED-CHAN-HT*`](#api-variable-registered-chan-ht_AB9603E8113B072ED62C83686B3BA300)
      1. [PACKAGE: `TCLISH`](#api-package-tclish_E333D0E718CF4EE4D714577E7371B15D)
         1. [CFFI-STRUCT: `TCL-EV-QUEUE-CB-EVT-S`](#api-cffi-struct-tcl-ev-queue-cb-evt-s_772F6E3C37833EA1029207FEA6E9856B)
         1. [CFFI-TYPE: `CALL-WHEN-DELETED-CB-COUNTER-T`](#api-cffi-type-call-when-deleted-cb-counter-t_429B10ED3DE1D0808ABF1AE9CFDC6F01)
         1. [CFFI-TYPE: `CMD-CB-COUNTER-T`](#api-cffi-type-cmd-cb-counter-t_B2083BD2B6F77741B83E1D446709C3C3)
         1. [CFFI-TYPE: `INTERP-TRACE-CB-COUNTER-T`](#api-cffi-type-interp-trace-cb-counter-t_DF89425EEB0F2B49D89F8DB5A60CFC5E)
         1. [CFFI-TYPE: `TCL-EV-QUEUE-CB-COUNTER-T`](#api-cffi-type-tcl-ev-queue-cb-counter-t_CC564BE46DC059523CAADA1B0D4496FA)
         1. [CFFI-TYPE: `TCL-EV-QUEUE-CB-EVT-S-PTR`](#api-cffi-type-tcl-ev-queue-cb-evt-s-ptr_555ECC2EB1387D5DBE9D5646C1B0B006)
         1. [CFFI-TYPE: `TRACE-CMD-CB-COUNTER-T`](#api-cffi-type-trace-cmd-cb-counter-t_C422CBEBD94A427B09ACE009A5ED6B88)
         1. [CFFI-TYPE: `TRACE-VAR-CB-COUNTER-T`](#api-cffi-type-trace-var-cb-counter-t_10DE3F70BA861D97F01BB580CA80F522)
         1. [CLASS: `<TCL-ARRAY-LINK>`](#api-class-tcl-array-link_D0612FF4394C17B2FB6778BC2E6734DC)
         1. [CLASS: `<TCL-CMD-TRACE>`](#api-class-tcl-cmd-trace_AEBDE544718F704D3CB9FFFF62FF9EDF)
         1. [CLASS: `<TCL-VAR-LINK-BASE>`](#api-class-tcl-var-link-base_998A718F42F3EADAF6076CC50F752F0E)
         1. [CLASS: `<TCL-VAR-LINK>`](#api-class-tcl-var-link_864D035C008D276E36854FAAC5E52566)
         1. [CLASS: `<TCL-VAR-TRACE>`](#api-class-tcl-var-trace_FA9F54D5A6A3F6860AEB4BF6EE0F6FD4)
         1. [CLASS: `TCL-EV-QUEUE-CB-EVT-S-TCLASS`](#api-class-tcl-ev-queue-cb-evt-s-tclass_8FAFE5C78AAEB9217FBDC5AB93A512DB)
         1. [CONDITION: `<TCL-ERROR>`](#api-condition-tcl-error_F2092D149C2116B80047F00C51F79E78)
         1. [FUNCTION: `%CMD-CB-COUNTER-VALUE-FROM-C`](#api-function-cmd-cb-counter-value-from-c_B37C1BDE041B123B9A84700FDE408F87)
         1. [FUNCTION: `%CMD-CB-COUNTER-VALUE-FROM-C`](#api-function-cmd-cb-counter-value-from-c_B37C1BDE041B123B9A84700FDE408F87)
         1. [FUNCTION: `%COMPOSE-NS-FQN`](#api-function-compose-ns-fqn_429C7FEB5EDEF9F5BA148926B986BE2E)
         1. [FUNCTION: `%TCL-EV-QUEUE-CB-COUNTER/VALUE-FROM-C`](#api-function-tcl-ev-queue-cb-countervalue-from-c_FA0D11861888016B2A31C5236DD8C6F3)
         1. [FUNCTION: `%TCL-EV-QUEUE-CB-COUNTER/VALUE-FROM-C`](#api-function-tcl-ev-queue-cb-countervalue-from-c_FA0D11861888016B2A31C5236DD8C6F3)
         1. [FUNCTION: `->FLAGS-BITS*`](#api-function-flags-bits_7D7D84CD232201E7DAD97CDC40E6F3F1)
         1. [FUNCTION: `->FLAGS-BITS`](#api-function-flags-bits_3BFD46FDB58C30CAEEA3E21815BCE030)
         1. [FUNCTION: `->TCL-STRING-OBJ%`](#api-function-tcl-string-obj_90E47944DE749532AF4A1C9D860F2C9E)
         1. [FUNCTION: `->TCL-STRING-OBJ`](#api-function-tcl-string-obj_6F4E4F1FB8DF72A715E486DBF91F58FE)
         1. [FUNCTION: `<-FLAGS-BITS`](#api-function-flags-bits_B3AA2DBDE26E2281CD14B8B55FE32C7F)
         1. [FUNCTION: `<-TCL-INT-BOOL`](#api-function-tcl-int-bool_0F37E8C5223660286FF8C9905E52AC34)
         1. [FUNCTION: `ALIAS/GET`](#api-function-aliasget_06FB3B5707003C3E1BC39DD827E4C285)
         1. [FUNCTION: `ALIAS/OBJ`](#api-function-aliasobj_03F439710E33CFDBD7362BC03589AD15)
         1. [FUNCTION: `ALIAS/STR`](#api-function-aliasstr_080C85487D4AA9CEB7C22143714771A2)
         1. [FUNCTION: `ALIST->TCL-DICT`](#api-function-alist-tcl-dict_BB0C66EF329A1AA4CF19BAAB604EFE6E)
         1. [FUNCTION: `APPLY-LAMBDA`](#api-function-apply-lambda_8A7546D583FFE2ACC9F86267719083A2)
         1. [FUNCTION: `CALL-WHEN-DELETED/+ADD`](#api-function-call-when-deletedadd_B22D396B5C8FDCB0B4FAF7ABAAEAE6C3)
         1. [FUNCTION: `CALL-WHEN-DELETED/-DEL`](#api-function-call-when-deleted-del_5610DB497329F7995AD642E77B21E006)
         1. [FUNCTION: `CALL-WHEN-DELETED/ALLOC-COUNTER-CFFI`](#api-function-call-when-deletedalloc-counter-cffi_1B4170644CC6DEB69E4F73DEFC3DEF0F)
         1. [FUNCTION: `CALL-WHEN-DELETED/CB`](#api-function-call-when-deletedcb_FCF110E326223A27750E938BCA15241A)
         1. [FUNCTION: `CALL-WHEN-DELETED/CB`](#api-function-call-when-deletedcb_FCF110E326223A27750E938BCA15241A)
         1. [FUNCTION: `CALL-WHEN-DELETED/COUNTER-CFFI`](#api-function-call-when-deletedcounter-cffi_5F2931E782311E2364CC48E166A2BA6B)
         1. [FUNCTION: `CALL-WHEN-DELETED/COUNTER-CFFI`](#api-function-call-when-deletedcounter-cffi_5F2931E782311E2364CC48E166A2BA6B)
         1. [FUNCTION: `CALL-WHEN-DELETED/DEL-CB`](#api-function-call-when-deleteddel-cb_7A560A81CF3AC9A17F391262B594C203)
         1. [FUNCTION: `CALL-WHEN-DELETED/FREE-COUNTER-CFFI`](#api-function-call-when-deletedfree-counter-cffi_D53E81E0D847EFE01393D43796F02D6D)
         1. [FUNCTION: `CALL-WHEN-DELETED/INCR-COUNT`](#api-function-call-when-deletedincr-count_8B7889F8772A1897FB9A24358DCECCDB)
         1. [FUNCTION: `CALL-WHEN-DELETED/REGIST-CB`](#api-function-call-when-deletedregist-cb_4872E84FFEFDD4F6BE4C39775AE2381D)
         1. [FUNCTION: `CALL-WHEN-DELETED/ROUTE-BY-CLIENT-DATA`](#api-function-call-when-deletedroute-by-client-data_9B6B901E0220A4A9F9C332B92A36B5F7)
         1. [FUNCTION: `CALL-WHEN-DELETED/UNREGIST-CB`](#api-function-call-when-deletedunregist-cb_C2682D8FDA6F2AFDAB7A7835949FB5C9)
         1. [FUNCTION: `CHK-GET/SET-VAR-AS-TYPE`](#api-function-chk-getset-var-as-type_D84D65322BA254C99AEFBEB25A9BAC65)
         1. [FUNCTION: `CMD-INFO/FREE`](#api-function-cmd-infofree_7CE86BF8CD6EE142AC1E54EE9AB96411)
         1. [FUNCTION: `CMD-INFO/FROM-CMD-OBJ`](#api-function-cmd-infofrom-cmd-obj_90D20C3B0CBFBCAD440B0DBFA4882104)
         1. [FUNCTION: `CMD-INFO/FROM-CMD-OBJ`](#api-function-cmd-infofrom-cmd-obj_90D20C3B0CBFBCAD440B0DBFA4882104)
         1. [FUNCTION: `CMD-INFO/FULL-NAME`](#api-function-cmd-infofull-name_CA1A1A74F237C8F3ECA54A0B8D7C4827)
         1. [FUNCTION: `CREATE-ENSEMBLE`](#api-function-create-ensemble_D3A5E5B328375313EC151784FB130D4F)
         1. [FUNCTION: `CREATE-OBJ-COMMAND`](#api-function-create-obj-command_FE8CA501C9A0EF6F0962122420E4EF6C)
         1. [FUNCTION: `CREATE-STRING-COMMAND`](#api-function-create-string-command_0096EE9DB579073F1EC3C3DFAE173CC3)
         1. [FUNCTION: `DEF-CMD/P`](#api-function-def-cmdp_9480FC024D041FA820CCA366CF6FEF03)
         1. [FUNCTION: `ENSEMBLE/EXCLUDE`](#api-function-ensembleexclude_ABCE680CE846B2811BC2763A281AD85D)
         1. [FUNCTION: `ENSEMBLE/INCLUDE`](#api-function-ensembleinclude_6415BF0E9239013E94F13232BECC286F)
         1. [FUNCTION: `ENSEMBLE/RENAME`](#api-function-ensemblerename_F7776BD211CF39E6E448CF8433BF63D7)
         1. [FUNCTION: `EVAL-TCL/STR`](#api-function-eval-tclstr_15D307888B21AA403BE5948E4D6D1040)
         1. [FUNCTION: `EVAL-TCL/TCL-OBJ-LIST`](#api-function-eval-tcltcl-obj-list_38D7441FA433D57AF6B07E8C77BBEE6D)
         1. [FUNCTION: `EVAL-TCL/TCL-OBJV`](#api-function-eval-tcltcl-objv_789A16C7EC55076932FD543BAAABF1E2)
         1. [FUNCTION: `EVAL-TCL/TCL-STRING`](#api-function-eval-tcltcl-string_8FB8B82AE186050302F19169E9426191)
         1. [FUNCTION: `EVAL-TCL`](#api-function-eval-tcl_DC3765A0EB21F760ADBD6F059A3BC2F1)
         1. [FUNCTION: `FLAGS-BIT?`](#api-function-flags-bit_91FAE56118B55F8CD5CAEADAB96B801E)
         1. [FUNCTION: `FREE-TCL-OBJV`](#api-function-free-tcl-objv_EC574190EBD390E3102CB44A9568687F)
         1. [FUNCTION: `GET-VAR/OBJ`](#api-function-get-varobj_0357AA3AD251EAA430D140E945CB6EC4)
         1. [FUNCTION: `GET-VAR/STR`](#api-function-get-varstr_F256B7EB898A5E1D9D490F73DAD9FC73)
         1. [FUNCTION: `GET-VAR`](#api-function-get-var_F90E54C20EB08DA104FCB9B0D274C8CA)
         1. [FUNCTION: `HT->TCL-DICT`](#api-function-ht-tcl-dict_1DB382370423DC0B3869B9FD92B64E8A)
         1. [FUNCTION: `INTERP-TRACE/+TRACE`](#api-function-interp-tracetrace_D8D7B6FDBDAA24C324C6DED5C8CAC827)
         1. [FUNCTION: `INTERP-TRACE/-DELETE`](#api-function-interp-trace-delete_678C61D91FB8E56BB7455E661DFE23A6)
         1. [FUNCTION: `INTERP-TRACE/ALLOC-COUNTER-CFFI`](#api-function-interp-tracealloc-counter-cffi_FCD72476DA1641EFF7EFC2125B3047F2)
         1. [FUNCTION: `INTERP-TRACE/CB`](#api-function-interp-tracecb_00BF2063C858546642116F2240339F70)
         1. [FUNCTION: `INTERP-TRACE/CB`](#api-function-interp-tracecb_00BF2063C858546642116F2240339F70)
         1. [FUNCTION: `INTERP-TRACE/COUNTER-CFFI`](#api-function-interp-tracecounter-cffi_8AE3588A11ED13BBD5E1BDC0CAF3C867)
         1. [FUNCTION: `INTERP-TRACE/COUNTER-CFFI`](#api-function-interp-tracecounter-cffi_8AE3588A11ED13BBD5E1BDC0CAF3C867)
         1. [FUNCTION: `INTERP-TRACE/DEL-CB`](#api-function-interp-tracedel-cb_71BF5C5AE2741CDCE9E3552F271627A2)
         1. [FUNCTION: `INTERP-TRACE/FREE-COUNTER-CFFI`](#api-function-interp-tracefree-counter-cffi_82F1CDC87645DE9FD7326AC50FD4CCA8)
         1. [FUNCTION: `INTERP-TRACE/INCR-COUNT`](#api-function-interp-traceincr-count_E5C90DF50CE10994DF421DC658D6D31B)
         1. [FUNCTION: `INTERP-TRACE/REGIST-CB`](#api-function-interp-traceregist-cb_6067E1C3C4A15B1A72E3ACAA3FA46E4F)
         1. [FUNCTION: `INTERP-TRACE/ROUTE-BY-CLIENT-DATA`](#api-function-interp-traceroute-by-client-data_1F2E1E0A369104CB71878C83061B27C7)
         1. [FUNCTION: `INTERP-TRACE/UNREGIST-CB`](#api-function-interp-traceunregist-cb_B7CD17C1470D884E01ADB71193CBE202)
         1. [FUNCTION: `INTERP/ACTIVE?`](#api-function-interpactive_94E5FB2683D3675FBBA8416C8CD5C38F)
         1. [FUNCTION: `INTERP/CHILD`](#api-function-interpchild_CD58C22B8EF6AF0D25A35233598D31F7)
         1. [FUNCTION: `INTERP/CREATE-CHILD`](#api-function-interpcreate-child_3FA0D36BFEDAE757BB5719352F6E5A96)
         1. [FUNCTION: `INTERP/DELETED?`](#api-function-interpdeleted_C6F4500F48C91059E6184A398A412D28)
         1. [FUNCTION: `INTERP/EXPOSE-CMD`](#api-function-interpexpose-cmd_8B4088CF57B04CAE8044E8E47EA06295)
         1. [FUNCTION: `INTERP/HIDE-CMD`](#api-function-interphide-cmd_27442766E6C9007C05186ADC27F6A3D1)
         1. [FUNCTION: `INTERP/INTERP-PATH`](#api-function-interpinterp-path_F443736D4FEB3A65FA6A3996482981C2)
         1. [FUNCTION: `INTERP/PARENT`](#api-function-interpparent_16CA562AAA8128F576841B2B03015990)
         1. [FUNCTION: `INTERP/SAFE?`](#api-function-interpsafe_0965176DEEEDDB6EE6A5D0F385695552)
         1. [FUNCTION: `LINK/+ARRAY`](#api-function-linkarray_94107B1539BD67FFFD3FBBD6F1D1958B)
         1. [FUNCTION: `LINK/+VAR`](#api-function-linkvar_69C66240D0A9CF34C3D556C4F50FB6ED)
         1. [FUNCTION: `LINK/-UNLINK`](#api-function-link-unlink_6B260269B3A3CB233B5DED3FC58EABF7)
         1. [FUNCTION: `LINK/ALLOC-ARRAY`](#api-function-linkalloc-array_BB6FD2438D4ACF001526703F3FF92C65)
         1. [FUNCTION: `LINK/ALLOC-VAR-STR`](#api-function-linkalloc-var-str_1E5F72583D0FF93E332DE40F3162397D)
         1. [FUNCTION: `LINK/ALLOC-VAR`](#api-function-linkalloc-var_AE3C05E27A037306EEAFCEDF0838F526)
         1. [FUNCTION: `LINK/ARRAY-CFFI-TYPE`](#api-function-linkarray-cffi-type_1C1C176EA96629EC2643298421D05C12)
         1. [FUNCTION: `LINK/ARRAY-TYPE?`](#api-function-linkarray-type_DFD7F4A08A95680C150FF949168ADF17)
         1. [FUNCTION: `LINK/COMMON-TYPE?`](#api-function-linkcommon-type_14D338651C01BEA84700943C13B428A4)
         1. [FUNCTION: `LINK/FREE-ARRAY`](#api-function-linkfree-array_C0955AFC6BF89CCCA5193D8E91C53E1E)
         1. [FUNCTION: `LINK/FREE-VAR-STR`](#api-function-linkfree-var-str_2CBF5B1B1B18840412CD1E2D4FA176DA)
         1. [FUNCTION: `LINK/FREE-VAR`](#api-function-linkfree-var_445141701991B4C607BD82C7CBFAF4AB)
         1. [FUNCTION: `LINK/READ-ARRAY`](#api-function-linkread-array_04D3271675646175306C6858A0F2247B)
         1. [FUNCTION: `LINK/READ-VAR-STR`](#api-function-linkread-var-str_72071FFDA601EE3348309CD790228EF2)
         1. [FUNCTION: `LINK/READ-VAR`](#api-function-linkread-var_2047D6DBC351FE6A5C29659DB0B28090)
         1. [FUNCTION: `LINK/UPDATE`](#api-function-linkupdate_6812AB85A4A3B7F0BCA2A741DD7BC3D8)
         1. [FUNCTION: `LINK/VAR-CFFI-TYPE`](#api-function-linkvar-cffi-type_B02CEDE7C9748B5B15748648C26180EB)
         1. [FUNCTION: `LINK/VAR-TYPE?`](#api-function-linkvar-type_34FF36B6024887EEFE0762F025154481)
         1. [FUNCTION: `LINK/WRITE-ARRAY`](#api-function-linkwrite-array_32904357253ED3410E4E138FDB53A583)
         1. [FUNCTION: `LINK/WRITE-VAR-STR`](#api-function-linkwrite-var-str_2F61BF5DB3592ABE808DBA613CD83B96)
         1. [FUNCTION: `LINK/WRITE-VAR`](#api-function-linkwrite-var_4ADCDE5A6C6C848B18E39A73FEF4B21B)
         1. [FUNCTION: `LISP-BOOL->C-INT`](#api-function-lisp-bool-c-int_5006FFCE39DEE304EAE6F18D17655673)
         1. [FUNCTION: `LISP-VALUE-OR-NULLPTR`](#api-function-lisp-value-or-nullptr_1B1D87DEC0EAEF9FC0CAB30A23357EB1)
         1. [FUNCTION: `LIST->TCL-LIST`](#api-function-list-tcl-list_DD5023EBB9B299993C460D5F1A372F21)
         1. [FUNCTION: `LIST->TCL-STRING-LIST`](#api-function-list-tcl-string-list_DF9F89B7B538CC4F6F8DCBA211C41097)
         1. [FUNCTION: `MNT-ZIPFS`](#api-function-mnt-zipfs_4FD522735941AF5F638C7B662F6F59D3)
         1. [FUNCTION: `NULLPTR->NIL`](#api-function-nullptr-nil_3863281E2BF50E6C20677107D5195126)
         1. [FUNCTION: `OBJV->TCL-OBJ-LIST`](#api-function-objv-tcl-obj-list_3A79645A5F9ED721B7A838F1CD129336)
         1. [FUNCTION: `PACK-TCL-ERROR`](#api-function-pack-tcl-error_6C604C87770565E469B9099BD6EE60AF)
         1. [FUNCTION: `QUEUE-EVT-FUNC`](#api-function-queue-evt-func_E2B986AC3E80DFF0F3C9339CA2086000)
         1. [FUNCTION: `REMHASH-BY-VALUE`](#api-function-remhash-by-value_8042B598E655FFC9F1A417EC07306816)
         1. [FUNCTION: `RESULT-AS`](#api-function-result-as_30C1DDB3C198AC4541BBC94D1BC4D26B)
         1. [FUNCTION: `SET-TCL-RESULT-FROM-ERROR`](#api-function-set-tcl-result-from-error_E64D65F1BB7831963D0990CC364198FE)
         1. [FUNCTION: `SET-TCL-RESULT-STRING`](#api-function-set-tcl-result-string_82AE2AA171037E491DCE4200B2435590)
         1. [FUNCTION: `SET-VAR/OBJ`](#api-function-set-varobj_F4E90A5DD13E210B4ABDBAEC2FCC9AB1)
         1. [FUNCTION: `SET-VAR/STR`](#api-function-set-varstr_B45580CA72A8BD8B5524A2998B2FF406)
         1. [FUNCTION: `SET-VAR`](#api-function-set-var_C6C86F9D0DF4F9102C07EE63901F56B8)
         1. [FUNCTION: `STR->TCL-ALLOCED-CHARP`](#api-function-str-tcl-alloced-charp_D38EF3E40511C2DC04EC2DBD4886A91C)
         1. [FUNCTION: `TCL-NS`](#api-function-tcl-ns_7B3139E774070EDA6B2C54ADFFDC6C8F)
         1. [FUNCTION: `TCL-OBJ-LIST->OBJV`](#api-function-tcl-obj-list-objv_655BF97466CF5566084893EE3A2FA6B5)
         1. [FUNCTION: `TCL-OBJ-LIST->TCL-LIST`](#api-function-tcl-obj-list-tcl-list_285C3F25B208855EE68DB14CC463AA0A)
         1. [FUNCTION: `TCL-RESULT-AS-ERROR`](#api-function-tcl-result-as-error_88480C0DF132A646905B1B4F527C284A)
         1. [FUNCTION: `TRACE-CMD/+TRACE`](#api-function-trace-cmdtrace_A74A697127FE7F50B669C348BE519E1D)
         1. [FUNCTION: `TRACE-CMD/-UNTRACE`](#api-function-trace-cmd-untrace_D1FF9780487CED9AFF989FF3D0670577)
         1. [FUNCTION: `TRACE-CMD/ALLOC-COUNTER-CFFI`](#api-function-trace-cmdalloc-counter-cffi_1ED83E061D46AD631544E009CDBBF22A)
         1. [FUNCTION: `TRACE-CMD/CB`](#api-function-trace-cmdcb_3FE51CE702D402C51C03031857C24578)
         1. [FUNCTION: `TRACE-CMD/CB`](#api-function-trace-cmdcb_3FE51CE702D402C51C03031857C24578)
         1. [FUNCTION: `TRACE-CMD/COUNTER-CFFI`](#api-function-trace-cmdcounter-cffi_3E1C13DB638FB35861BAF72607901181)
         1. [FUNCTION: `TRACE-CMD/COUNTER-CFFI`](#api-function-trace-cmdcounter-cffi_3E1C13DB638FB35861BAF72607901181)
         1. [FUNCTION: `TRACE-CMD/DEL-CB`](#api-function-trace-cmddel-cb_6903975216C1C6AD47316A6C285CD7D0)
         1. [FUNCTION: `TRACE-CMD/ENFORCE-FLAGS`](#api-function-trace-cmdenforce-flags_51F48548CA364778AEFA84DDD54F3684)
         1. [FUNCTION: `TRACE-CMD/FREE-COUNTER-CFFI`](#api-function-trace-cmdfree-counter-cffi_A1EBA48195236397ECA702B610C6305A)
         1. [FUNCTION: `TRACE-CMD/INCR-COUNT`](#api-function-trace-cmdincr-count_511C829ABA0981FB79DFBB42E60EB907)
         1. [FUNCTION: `TRACE-CMD/LIST-ALL`](#api-function-trace-cmdlist-all_7FCA16F23F467EAEAEE5A57B9A0C6B9F)
         1. [FUNCTION: `TRACE-CMD/REGIST-CB`](#api-function-trace-cmdregist-cb_9F6889831983909E450098554BEEC2F3)
         1. [FUNCTION: `TRACE-CMD/ROUTE-BY-CLIENT-DATA`](#api-function-trace-cmdroute-by-client-data_1805925E9D5932ACBB52963BCD4866A1)
         1. [FUNCTION: `TRACE-CMD/UNREGIST-CB`](#api-function-trace-cmdunregist-cb_85793B3F4C507325D02304C333B4BB4E)
         1. [FUNCTION: `TRACE-VAR/+TRACE`](#api-function-trace-vartrace_FD4C78E3F753B0E629DB1DC6216D9E97)
         1. [FUNCTION: `TRACE-VAR/-UNTRACE`](#api-function-trace-var-untrace_4749EE47F32C5F11F64DD33F5DBBA95D)
         1. [FUNCTION: `TRACE-VAR/ALLOC-COUNTER-CFFI`](#api-function-trace-varalloc-counter-cffi_657CE1763F4B24307130582C09CD4BB9)
         1. [FUNCTION: `TRACE-VAR/CB`](#api-function-trace-varcb_B8A251862B5183F311A0C183618563E3)
         1. [FUNCTION: `TRACE-VAR/CB`](#api-function-trace-varcb_B8A251862B5183F311A0C183618563E3)
         1. [FUNCTION: `TRACE-VAR/COUNTER-CFFI`](#api-function-trace-varcounter-cffi_D9D037D8E0040EAE39CFA4A3EDB59226)
         1. [FUNCTION: `TRACE-VAR/COUNTER-CFFI`](#api-function-trace-varcounter-cffi_D9D037D8E0040EAE39CFA4A3EDB59226)
         1. [FUNCTION: `TRACE-VAR/DEL-CB`](#api-function-trace-vardel-cb_42B2070C1B7899ED7A13D44390915018)
         1. [FUNCTION: `TRACE-VAR/ENFORCE-FLAGS`](#api-function-trace-varenforce-flags_495585F9E5A99BD789071E66BB7A141E)
         1. [FUNCTION: `TRACE-VAR/FREE-COUNTER-CFFI`](#api-function-trace-varfree-counter-cffi_E947301BDE5CE35DBF7029D89AFC3901)
         1. [FUNCTION: `TRACE-VAR/INCR-COUNT`](#api-function-trace-varincr-count_981775BC97B5F50E09F258A39D1E137B)
         1. [FUNCTION: `TRACE-VAR/LIST-ALL`](#api-function-trace-varlist-all_5955F243F0BFBAE07CF1A7B43AF156FB)
         1. [FUNCTION: `TRACE-VAR/REGIST-CB`](#api-function-trace-varregist-cb_6D9220B40DCF2477330E80CD56ABE675)
         1. [FUNCTION: `TRACE-VAR/ROUTE-BY-CLIENT-DATA`](#api-function-trace-varroute-by-client-data_138D9A8ABE0AEAFBF46AC5DF354783E8)
         1. [FUNCTION: `TRACE-VAR/UNREGIST-CB`](#api-function-trace-varunregist-cb_6407E8AFF00CB0485E358492444EC6E5)
         1. [FUNCTION: `UMNT-ZIPFS`](#api-function-umnt-zipfs_05D029300A736BCC96C13FE6C811F3CE)
         1. [FUNCTION: `UNSET-VAR`](#api-function-unset-var_C3F36293AD59CD0AB54EB68603D03117)
         1. [FUNCTION: `WRAP-ERROR*`](#api-function-wrap-error_2EB742DBF7465D81D1226715555B963B)
         1. [FUNCTION: `WRAP-ERROR`](#api-function-wrap-error_740EB6BA24804D761A0786F661F71744)
         1. [FUNCTION: `WRAP-RESULT`](#api-function-wrap-result_BD90A9735958013B7DA9E33B6794197C)
         1. [MACRO: `%DEFUN-CREATE-COMMAND`](#api-macro-defun-create-command_3671337BCC6B101FFC4EB45D517AD8BE)
         1. [MACRO: `%TCL-CMD-PROC-CFFI-CALLBACK-BODY`](#api-macro-tcl-cmd-proc-cffi-callback-body_583D31DBEA5426DB7BA4532EB1DEBE51)
         1. [MACRO: `APP-MAIN`](#api-macro-app-main_96B26B543F313711FC65BF84B4E8D15A)
         1. [MACRO: `DEF-CMD`](#api-macro-def-cmd_A944F19F7D14711CA81C5E1856F940D3)
         1. [MACRO: `DEF-ENSEMBLE`](#api-macro-def-ensemble_89A74F29323FAFDDE57F72F41762FDE2)
         1. [MACRO: `DEF-TCL-CALLBACK-PATTERN`](#api-macro-def-tcl-callback-pattern_F73B15D6F4F58D1579444E922A276C7A)
         1. [MACRO: `DO+CHK`](#api-macro-dochk_F2D2ED544BF1962D1CAEABE423F3245B)
         1. [MACRO: `NCONCF-IF`](#api-macro-nconcf-if_5E5B27D99B6CE44FE13D6D1517DCBE85)
         1. [MACRO: `QUEUE-EVT`](#api-macro-queue-evt_AA149FB6F9FB0D8BB5232AF43738430C)
         1. [MACRO: `TRACK-DEF-CMDS`](#api-macro-track-def-cmds_7B2DAFF84BA57FD399D2FEAEC46B6586)
         1. [MACRO: `WITH-CMD-INFO`](#api-macro-with-cmd-info_A8DC4811B0B3BBA57B08B14BBE61C7F5)
         1. [MACRO: `WITH-INTERP`](#api-macro-with-interp_92FA276533D47FA30402607B0E838E22)
         1. [MACRO: `WITH-TCL-ERROR/RESULT`](#api-macro-with-tcl-errorresult_076A9135EE5C56C72F959364B080AA52)
         1. [MACRO: `WITH-TCL-ERROR/THROWN`](#api-macro-with-tcl-errorthrown_7B7AE1A6816A3A54C8E401950286D44F)
         1. [MACRO: `WITH-TCL-OBJV`](#api-macro-with-tcl-objv_126AB448CDEC71DD3AFFC9B1C41E6E1F)
         1. [METHOD: `DESTROY` `((ARR-LINK <TCL-ARRAY-LINK>))`](#api-method-destroy-arr-link-tcl-array-link_D7BA1527057A08AE895D0C48ED370B10)
         1. [METHOD: `DESTROY` `((VAR-LINK <TCL-VAR-LINK>))`](#api-method-destroy-var-link-tcl-var-link_8686687800D7ECD054FA799561558900)
         1. [METHOD: `LINKED-VALUE-AT` `((ARR-LINK <TCL-ARRAY-LINK>) INDEX)`](#api-method-linked-value-at-arr-link-tcl-array-link-index_E611DDD7F1DA85A057ACF311BFA45217)
         1. [METHOD: `LINKED-VALUE-AT` `(NEW-VALUE (ARR-LINK <TCL-ARRAY-LINK>) INDEX)`](#api-method-linked-value-at-new-value-arr-link-tcl-array-link-index_2A7EE1EA44DD62B34B5F948CFF8C8712)
         1. [METHOD: `LINKED-VALUE` `((VAR-LINK <TCL-VAR-LINK>))`](#api-method-linked-value-var-link-tcl-var-link_D10344D5AEDDD624B90B7D61A61D6ECF)
         1. [METHOD: `LINKED-VALUE` `(NEW-VALUE (VAR-LINK <TCL-VAR-LINK>))`](#api-method-linked-value-new-value-var-link-tcl-var-link_7F781FD6C8984B6F0658EC2CBBED0BE1)
         1. [METHOD: `UNTRACE-CMD` `((CMD-TRACE <TCL-CMD-TRACE>))`](#api-method-untrace-cmd-cmd-trace-tcl-cmd-trace_FDC117D5840D3AD4952344F5044AA884)
         1. [METHOD: `UNTRACE-VAR` `((VAR-TRACE <TCL-VAR-TRACE>))`](#api-method-untrace-var-var-trace-tcl-var-trace_00B6504FF831ADB80FE5EB8B0B633603)
         1. [METHOD: `UPDATE` `((VAR-LINK <TCL-VAR-LINK-BASE>))`](#api-method-update-var-link-tcl-var-link-base_5B86EC8A9BD7D8B4F2F4D2BD61F21B4F)
         1. [VARIABLE: `*CALL-WHEN-DELETED-CB-COUNTER*`](#api-variable-call-when-deleted-cb-counter_6B63968B507AEA6574EF18A50A1EDC9C)
         1. [VARIABLE: `*CALL-WHEN-DELETED-CB-HT*`](#api-variable-call-when-deleted-cb-ht_870AB83210232DE593AC0C7EBD2BD0AF)
         1. [VARIABLE: `*CALL-WHEN-DELETED-CB-LOCK*`](#api-variable-call-when-deleted-cb-lock_89AD5D11001C4953396FB6B27F2DB57F)
         1. [VARIABLE: `*DEF-CMD-NS*`](#api-variable-def-cmd-ns_A34D0EA43D7AEF6B28059317E9292905)
         1. [VARIABLE: `*DEF-CMD-TRACKER*`](#api-variable-def-cmd-tracker_DD0D1C8B76825CCC9B9E66FE68F34DAA)
         1. [VARIABLE: `*DEF-CMD-TRACKING-HT*`](#api-variable-def-cmd-tracking-ht_89C9B1E27A5ADA42AF3266AA769F03E6)
         1. [VARIABLE: `*DO+CHK/ERROR?*`](#api-variable-dochkerror_9F794C1DCE6D7E141473980FDF2F1261)
         1. [VARIABLE: `*INTERP-TRACE-CB-COUNTER*`](#api-variable-interp-trace-cb-counter_F09D08235BD24B699B06B4BFFA522473)
         1. [VARIABLE: `*INTERP-TRACE-CB-HT*`](#api-variable-interp-trace-cb-ht_E1EE036F30E3977FF446BC5084E6549F)
         1. [VARIABLE: `*INTERP-TRACE-CB-LOCK*`](#api-variable-interp-trace-cb-lock_DBD1664C50B8D614E0C672CBD66B8AEB)
         1. [VARIABLE: `*STRINGIFY-FOR-TCL-OBJ-FUNC*`](#api-variable-stringify-for-tcl-obj-func_A050BCAF4C8FAE7ED2E4C23D4A86A311)
         1. [VARIABLE: `*TCL-CMD-CB-COUNTER*`](#api-variable-tcl-cmd-cb-counter_C9D8FB2966F564F742A286F2EB0F13A9)
         1. [VARIABLE: `*TCL-CMD-LOCK*`](#api-variable-tcl-cmd-lock_E6AA155E1AE3420E3B198104330CC981)
         1. [VARIABLE: `*TCL-CMD-OBJ-CB-HT*`](#api-variable-tcl-cmd-obj-cb-ht_38B647D19321E53171842EE1D5AC73EE)
         1. [VARIABLE: `*TCL-CMD-STRING-CB-HT*`](#api-variable-tcl-cmd-string-cb-ht_9A59C79E489AD25D4524BD272A7D0257)
         1. [VARIABLE: `*TCL-EV-QUEUE-CB-COUNTER*`](#api-variable-tcl-ev-queue-cb-counter_CDA163123E7E5E7FFF1BB687F71D1121)
         1. [VARIABLE: `*TCL-EV-QUEUE-CB-HT*`](#api-variable-tcl-ev-queue-cb-ht_8E2952BD242D829A07EDE11EAF91FA12)
         1. [VARIABLE: `*TCL-EV-QUEUE-LOCK*`](#api-variable-tcl-ev-queue-lock_64ADE4DDCA4E36E0E4A35B14565B677F)
         1. [VARIABLE: `*TCL-INTERP*`](#api-variable-tcl-interp_F6FB251E08DFDAA91F1BBB1856099374)
         1. [VARIABLE: `*TRACE-CMD-CB-COUNTER*`](#api-variable-trace-cmd-cb-counter_5E34F48C2BB8201F2663D16ECE023CBA)
         1. [VARIABLE: `*TRACE-CMD-CB-HT*`](#api-variable-trace-cmd-cb-ht_093BD5DB8A2B5443309707FB27D18BB3)
         1. [VARIABLE: `*TRACE-CMD-CB-LOCK*`](#api-variable-trace-cmd-cb-lock_8FD316EF3455AFEA34EAFD535E5844FC)
         1. [VARIABLE: `*TRACE-VAR-CB-COUNTER*`](#api-variable-trace-var-cb-counter_7130538A735388A0016442A4D664388C)
         1. [VARIABLE: `*TRACE-VAR-CB-HT*`](#api-variable-trace-var-cb-ht_0550D95E2AAB9BAA6C76844B314961E0)
         1. [VARIABLE: `*TRACE-VAR-CB-LOCK*`](#api-variable-trace-var-cb-lock_C56BA92D08965F7DD7BBA61A1A21DB74)
         1. [VARIABLE: `*VAR-FLAGS*`](#api-variable-var-flags_834701E53627F1D07EED3985B82FDEF8)
         1. [VARIABLE: `+LINK/ARRAY-CFFI-TYPE-PLIST+`](#api-variable-linkarray-cffi-type-plist_797B035A60F41D1E73CD27831070C547)
         1. [VARIABLE: `+LINK/COMMON-CFFI-TYPE-PLIST+`](#api-variable-linkcommon-cffi-type-plist_88E61685C0D7E52AEEDAB11427F1F409)
         1. [VARIABLE: `+LINK/VAR-CFFI-TYPE-PLIST+`](#api-variable-linkvar-cffi-type-plist_D65D6EB27D8BB737044E1DD305CDE2E0)
         1. [VARIABLE: `+TCL-TRACE-LEVEL-ANY+`](#api-variable-tcl-trace-level-any_CCE42BCE5D2F56E6E7CFD46E04AB150E)
         1. [VARIABLE: `+TCL-TRACE-LEVEL-ONLY-TOP+`](#api-variable-tcl-trace-level-only-top_922CDE5F62BE416843089983CCD7457B)
         1. [VARIABLE: `+TCL-TRACE-LEVEL-ONLY-TOP-AND-ONE-MORE+`](#api-variable-tcl-trace-level-only-top-and-one-more_B9F9FE57B007992AF82A62549D67CA3E)

<a name="srcintromd_1F1968DB82DBDB250C1C2FC9B7B5E3E2"></a>

## Introduction

**`tclish`** is a Lisp wrapper around Tcl/Tk 9.0 C APIs, which
provides easier ways to interact with Tcl/Tk.

All with Easy and Powerful Lisp DSLs.

Interested? Please refer the "Examples" section below.


### Embedding Tcl/Tk Interpreter in Lisp application

```lisp
(app-main
    (:tk-init? t
     :tk-main-loop? t)

    (eval-tcl "button .btn -text {<esc>:q!} -command {destroy .}"
              "pack .btn"))
```

* [ZipFS](https://www.tcl-lang.org/man/tcl8.7/TclCmd/zipfs.html)
  supports builtin, your Lisp executable image is the new
  [Starkit](https://wiki.tcl-lang.org/page/Starkit) ⭐
* (*NOTE* Tk DSL will be available soon, I'm working on it😅)


### Extending Tcl/Tk in Lisp

```lisp
(def-cmd ("AWESOME_PROC")
    (format t "HI!: ~a ~a~%" interp args)
    :I-AM-A-RESULT-VALUE)

(eval-tcl "AWESOME_PROC"
          "puts {WAS Awesome}")
```






### Comparasion Table

A comparasion table with other great Tcl/Tk libraries for Common Lisp:

|                  | Points                                                                            |
|-----------------:|:----------------------------------------------------------------------------------|
|       **tclish** | based on complete Tcl/Tk 9.0 / CFFI Binding : `raw-cffi-tcl9`                     |
|                  | 😅 Need to be careful with DLLs, FFIs.                                            |
|                  | 🐥 Just born yesterday                                                            |
|                  | 🐣 Doesn't even have a proper Tk abstrations, (not yet, working on it)            |
|                  | 😍 Freely access internals of Tcl/Tk (a bit?)                                     |
|                  | 😅 Not widely tested, documented (not yet, working on it)                         |
|                  | 😍 Focused on integrating Tcl/Tk easily with Lisp                                 |
|                  | 😍 ZipFS supports builtin                                                         |
|                  | 🤩 I love working with it!                                                        |
|                  |                                                                                   |
|          **ltk** | using `wish` subprocess + pipe communication, thus not Tcl 8.6/9.0 specific.      |
|                  | 😍 No need to worry about DLLs, FFIs.                                             |
|                  | 😍 Very easy to writing a Tk application in Lisp.                                 |
|                  | 😍 Wonderful documentation                                                        |
|                  |                                                                                   |
|       **nodgui** | based on ltk                                                                      |
|                  | 😍 More modern, ttk, megawidgets...                                               |
|                  | 😍 Actively maintained (in 2026)                                                  |
|                  | 😍 Wonderful documentation                                                        |
|                  | 🙀 More heavier than ltk with OpenGL, SDL...                                      |
|                  |                                                                                   |
| **cl-simple-tk** | CFFI binding based.                                                               |
|                  | 😍 Very easy to write a Tk application in Lisp.                                   |
|                  | 😍 Lightweight CFFI bindings, only binds minimum C functions for writing Tk code. |
|                  | (not really an expert of this library)                                            |




<a name="srcexamplesmd_AA62A0DF0FC45CCB3A15A661B4D674EA"></a>

## Examples


```lisp
> (ql:quickload :tclish-examples)
> (tclish/examples/05-tk-main-loop:main-tk-main-loop)
```

1. [`tk_messageBox`](./examples/01-tk-msgbox.lisp)
   1. Very basic usage of `app-main` and `eval-tcl`.

1. [Create Tcl command with ease](./examples/02-def-cmd.lisp)
   1. Writing new Tcl command written in Lisp.
   1. Getting arguments from Tcl, returning a value, or raising an
      error.

1. [Threadin in Lisp-side, Tcl Event Queue](./examples/03-cmd-with-evtq.lisp)
   1. Utilise thread in Lisp of custom Tcl command.
   2. and How to give response in thread-safe way to the main Tcl
      thread, from background thread. (... by using
      `Tcl_ThreadQueueEvent`)

1. *Unstable* [Redirecting Tcl standard channel to Lisp stream](./examples/04-redir-stdout.lisp)
   1. Capture Tcl standard output channels (`stdout`, `stderr`) to
      Lisp streams like `*standard-output*`

1. [Tk "main-loop"](./examples/05-tk-main-loop.lisp)
   1. Creating simple Tcl/Tk application easily with `app-main`-macro.

1. [def-cmd in namespace](./examples/06-def-cmd-in-ns.lisp)
   1. How to regist custom commands within Tcl namespaces with
      `def-cmd`-macro.

1. [Tcl Ensembles + def-cmd](./examples/07-ensemble.lisp)
   1. How to group custom macros into a Tcl ensembles with
      `def-ensemble` and `def-cmd` macros.

1. [Applying Tcl Lambda](./examples/08-apply-lambda.lisp)
   1. Invoking callback (Tcl lambda list) from custom command written
      in Lisp.

1. [Getting result value from Tcl code evaluations](./examples/09-eval-tcl-result.lisp)

1. [Getting, Setting, and Unsetting Tcl variables with Tcl namespaces](./examples/10-tcl-var.lisp)

1. Auto-Synchronised Variables between Tcl and Lisp through Link
   Var/Array:
   1. [Link Unsigned Integer Variable](./examples/11-link-var-uint.lisp)
   1. [Link String Variable](./examples/12-link-var-string.lisp)
   1. [Link Fixed-Size Array](./examples/13-link-array-uint.lisp)

1. [Interpreter Cleanup Callback](./examples/14-call-when-deleted.lisp)

1. *Unstable* [Tracing Tcl Variables at Lisp](./examples/15-trace-var.lisp)

1. *Unstable* [Tracing Tcl Commands at Lisp](./examples/16-trace-cmd.lisp)

1. A good base to build a stepping debugger and performance profiler
   on:
   - [Interpreter Trace](./examples/17-interp-trace.lisp)

<a name="srcgetting-startedmd_A75A5DAA4F7310D9E1BEBC2021F72C16"></a>

## Dependencies

* [raw-cffi-tcl9](https://github.com/ageldama/raw-cffi-tcl9)


## Installation
* Put a symlink of the `.asd` file into your
  `$HOME/common-lisp`-directory, and:
  ```lisp
  > (asdf:clear-configuration)
  > (ql:quickload :tclish)
  ```
<a name="srcsupportmd_E54E17F75D771528488BEBED6C50185B"></a>


## Supporting

Enjoying this project? Consider supporting its growth via the Ethereum
address in [my profile](https://github.com/ageldama).
<a name="srclicensemd_59C292C7659785E1BB31D2B4B69534CC"></a>



## License

[Licensed under the MIT License](https://opensource.org/license/mit)

Please read the [./LICENSE](./LICENSE)

<a name="api-refs_523EACBA8CE3897B5EE91337B062B676"></a>
# APIs

<a name="api-package-tclishcffi_2A3BE0C95DB163CCF774EAC0DD1B4C4D"></a>
## PACKAGE: `TCLISH/CFFI`

<a name="api-cffi-function-c-memcpy_5AD0A0B62AB3FCE5F82DE4C864909DA0"></a>
### CFFI-FUNCTION: `C-MEMCPY`

- SCOPE: EXTERNAL
- CFFI NAME: `memcpy`
- CFFI RETURN-TYPE: `POINTER`
- LAMBDA LIST: `((TCLISH/CFFI::DEST :POINTER) (TCLISH/CFFI::SRC :POINTER)
 (TCLISH/CFFI::N :SIZE))`
- SETF? `NIL`


<a name="api-cffi-function-c-memset_645F8593538721721F184ADD6490BF4E"></a>
### CFFI-FUNCTION: `C-MEMSET`

- SCOPE: EXTERNAL
- CFFI NAME: `memset`
- CFFI RETURN-TYPE: `POINTER`
- LAMBDA LIST: `((TCLISH/CFFI::DEST :POINTER) (TCLISH/CFFI::VALUE :INT)
 (TCLISH/CFFI::SIZE :SIZE))`
- SETF? `NIL`


<a name="api-cffi-function-c-strlen_F2E4A72F57AE9F2B599FFA74765D0F73"></a>
### CFFI-FUNCTION: `C-STRLEN`

- SCOPE: EXTERNAL
- CFFI NAME: `strlen`
- CFFI RETURN-TYPE: `SIZE`
- LAMBDA LIST: `((TCLISH/CFFI::DEST :POINTER))`
- SETF? `NIL`


<a name="api-function-c-memcpy_405995BF3B003D5CD4B5B90C5F5ECE3B"></a>
### FUNCTION: `C-MEMCPY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::DEST TCLISH/CFFI::SRC TCLISH/CFFI::N)`
- SETF? `NIL`


<a name="api-function-c-memset_849BD33172C68D6D43DA423994A633DB"></a>
### FUNCTION: `C-MEMSET`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::DEST TCLISH/CFFI::VALUE TCLISH/CFFI::SIZE)`
- SETF? `NIL`


<a name="api-function-c-ptr-array-to-ptr-list_3C88A5EEB9F82313779A475997659444"></a>
### FUNCTION: `C-PTR-ARRAY-TO-PTR-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::PTR COUNT)`
- SETF? `NIL`


<a name="api-function-c-string-array-to-string-list_9C2C3F5DCCFA93E2D7E796CF26E4088D"></a>
### FUNCTION: `C-STRING-ARRAY-TO-STRING-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::PTR COUNT)`
- SETF? `NIL`


<a name="api-function-c-strlen_CA150F3ABD68C9E7E1B61B41321D4C9E"></a>
### FUNCTION: `C-STRLEN`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::DEST)`
- SETF? `NIL`


<a name="api-function-cffiallocbzero_13C2896536E0DB3C3F8E856DA35F5C99"></a>
### FUNCTION: `CFFI/ALLOC+BZERO`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::CFFI-TYPE)`
- SETF? `NIL`


<a name="api-macro-c-memset_08252D1E6FCD6DF0646685A623517990"></a>
### MACRO: `C-MEMSET*`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::PTR TCLISH/CFFI::CH TCLISH/CFFI::TYPE-SPEC)`
- SETF? `NIL`


<a name="api-macro-mem-zero_69B96029A4FB94A49F3425F4B8C5D2D6"></a>
### MACRO: `MEM-ZERO`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCLISH/CFFI::PTR TCLISH/CFFI::TYPE-SPEC)`
- SETF? `NIL`


<a name="api-package-tclishredir-to-outstream-chan_8F0BB6607E03DE2AC1AC5F88B42DAE56"></a>
## PACKAGE: `TCLISH/REDIR-TO-OUTSTREAM-CHAN`

<a name="api-cffi-type-chan-instance-counter-t_11484592A01B49C0726E6017A6835377"></a>
### CFFI-TYPE: `CHAN-INSTANCE-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT16`


<a name="api-class-redir-to-outstream-chan_8A128B3D278B2F76A50D20900C27D146"></a>
### CLASS: `<REDIR-TO-OUTSTREAM-CHAN>`

- SCOPE: EXTERNAL
- SLOTS:
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
- SUPERCLASSES: `NIL`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-function-new-instance-counter_0C03A6CF8CAF5BBC870337325D5ED628"></a>
### FUNCTION: `%NEW-INSTANCE-COUNTER`

- SCOPE: INTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-put-instance_5B0073A3ED3D68F0A54F5D28078D72BC"></a>
### FUNCTION: `%PUT-INSTANCE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(TCLISH/REDIR-TO-OUTSTREAM-CHAN::CHAN)`
- SETF? `NIL`


<a name="api-function-rem-instance_221D543AC3F2A2BFF3EA9F03213E6C32"></a>
### FUNCTION: `%REM-INSTANCE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(TCLISH/REDIR-TO-OUTSTREAM-CHAN::CHAN)`
- SETF? `NIL`


<a name="api-method-dealloc-chan-redir-to-outstream-chan_842F4377BF4B24449CE7AB0EE1B511CD"></a>
### METHOD: `DEALLOC` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((TCLISH/REDIR-TO-OUTSTREAM-CHAN::CHAN
  TCLISH/REDIR-TO-OUTSTREAM-CHAN:<REDIR-TO-OUTSTREAM-CHAN>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-regist-chan-redir-to-outstream-chan-key-tcl-interp-ptr-tcl-std-chan-type_0134F346B807C4B11A4D52F97B0204FD"></a>
### METHOD: `REGIST` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>) &KEY TCL-INTERP-PTR TCL-STD-CHAN-TYPE)`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((TCLISH/REDIR-TO-OUTSTREAM-CHAN::CHAN
  TCLISH/REDIR-TO-OUTSTREAM-CHAN:<REDIR-TO-OUTSTREAM-CHAN>)
 &KEY TCL-INTERP-PTR TCLISH/REDIR-TO-OUTSTREAM-CHAN:TCL-STD-CHAN-TYPE)`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-unregist-chan-redir-to-outstream-chan-key-tcl-interp-ptr_EAB1788FF7D662A3A7FE6C8D21383397"></a>
### METHOD: `UNREGIST` `((CHAN <REDIR-TO-OUTSTREAM-CHAN>) &KEY TCL-INTERP-PTR)`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((TCLISH/REDIR-TO-OUTSTREAM-CHAN::CHAN
  TCLISH/REDIR-TO-OUTSTREAM-CHAN:<REDIR-TO-OUTSTREAM-CHAN>)
 &KEY TCL-INTERP-PTR)`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-variable-chan-instance-counter_FB4018494A1840EA60EAA0E5BC717DEC"></a>
### VARIABLE: `*CHAN-INSTANCE-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-lock_382D682E7780D1D4397903094E17A83B"></a>
### VARIABLE: `*LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*lock*")`


<a name="api-variable-registered-chan-ht_AB9603E8113B072ED62C83686B3BA300"></a>
### VARIABLE: `*REGISTERED-CHAN-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-package-tclish_E333D0E718CF4EE4D714577E7371B15D"></a>
## PACKAGE: `TCLISH`

<a name="api-cffi-struct-tcl-ev-queue-cb-evt-s_772F6E3C37833EA1029207FEA6E9856B"></a>
### CFFI-STRUCT: `TCL-EV-QUEUE-CB-EVT-S`

- SCOPE: INTERNAL
- SLOTS:


<a name="api-cffi-type-call-when-deleted-cb-counter-t_429B10ED3DE1D0808ABF1AE9CFDC6F01"></a>
### CFFI-TYPE: `CALL-WHEN-DELETED-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT16`


<a name="api-cffi-type-cmd-cb-counter-t_B2083BD2B6F77741B83E1D446709C3C3"></a>
### CFFI-TYPE: `CMD-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT64`


<a name="api-cffi-type-interp-trace-cb-counter-t_DF89425EEB0F2B49D89F8DB5A60CFC5E"></a>
### CFFI-TYPE: `INTERP-TRACE-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT64`


<a name="api-cffi-type-tcl-ev-queue-cb-counter-t_CC564BE46DC059523CAADA1B0D4496FA"></a>
### CFFI-TYPE: `TCL-EV-QUEUE-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT64`


<a name="api-cffi-type-tcl-ev-queue-cb-evt-s-ptr_555ECC2EB1387D5DBE9D5646C1B0B006"></a>
### CFFI-TYPE: `TCL-EV-QUEUE-CB-EVT-S-PTR`

- SCOPE: INTERNAL
- BASE-TYPE: `(:POINTER (:STRUCT TCL-EV-QUEUE-CB-EVT-S))`


<a name="api-cffi-type-trace-cmd-cb-counter-t_C422CBEBD94A427B09ACE009A5ED6B88"></a>
### CFFI-TYPE: `TRACE-CMD-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT64`


<a name="api-cffi-type-trace-var-cb-counter-t_10DE3F70BA861D97F01BB580CA80F522"></a>
### CFFI-TYPE: `TRACE-VAR-CB-COUNTER-T`

- SCOPE: INTERNAL
- BASE-TYPE: `:UINT64`


<a name="api-class-tcl-array-link_D0612FF4394C17B2FB6778BC2E6734DC"></a>
### CLASS: `<TCL-ARRAY-LINK>`

- SCOPE: EXTERNAL
- SLOTS:
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
- SUPERCLASSES: `(<TCL-VAR-LINK-BASE>)`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-class-tcl-cmd-trace_AEBDE544718F704D3CB9FFFF62FF9EDF"></a>
### CLASS: `<TCL-CMD-TRACE>`

- SCOPE: EXTERNAL
- SLOTS:
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
- SUPERCLASSES: `NIL`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-class-tcl-var-link-base_998A718F42F3EADAF6076CC50F752F0E"></a>
### CLASS: `<TCL-VAR-LINK-BASE>`

- SCOPE: EXTERNAL
- SLOTS:
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
- SUPERCLASSES: `NIL`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-class-tcl-var-link_864D035C008D276E36854FAAC5E52566"></a>
### CLASS: `<TCL-VAR-LINK>`

- SCOPE: EXTERNAL
- SLOTS:
- SUPERCLASSES: `(<TCL-VAR-LINK-BASE>)`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-class-tcl-var-trace_FA9F54D5A6A3F6860AEB4BF6EE0F6FD4"></a>
### CLASS: `<TCL-VAR-TRACE>`

- SCOPE: EXTERNAL
- SLOTS:
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
   - SLOT `NIL` / TYPE: `NIL`
      - ALLOCATION: `NIL`
      - INITFORM: `NIL`
      - INITARG: `NIL`
      - ACCESSOR: `NIL`
      - READERS: `NIL`
      - WRITERS: `NIL`
- SUPERCLASSES: `NIL`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-class-tcl-ev-queue-cb-evt-s-tclass_8FAFE5C78AAEB9217FBDC5AB93A512DB"></a>
### CLASS: `TCL-EV-QUEUE-CB-EVT-S-TCLASS`

- SCOPE: INTERNAL
- SLOTS:
- SUPERCLASSES: `(CFFI::FOREIGN-STRUCT-TYPE CFFI::TRANSLATABLE-FOREIGN-TYPE)`
- METACLASS: `STANDARD-CLASS`
- DEFAULT-INITARGS: `NIL`
- TYPE: `NIL`


<a name="api-condition-tcl-error_F2092D149C2116B80047F00C51F79E78"></a>
### CONDITION: `<TCL-ERROR>`

- SCOPE: EXTERNAL


<a name="api-function-cmd-cb-counter-value-from-c_B37C1BDE041B123B9A84700FDE408F87"></a>
### FUNCTION: `%CMD-CB-COUNTER-VALUE-FROM-C`

- SCOPE: INTERNAL
- LAMBDA LIST: `(C-VAL)`
- SETF? `NIL`


<a name="api-function-cmd-cb-counter-value-from-c_B37C1BDE041B123B9A84700FDE408F87"></a>
### FUNCTION: `%CMD-CB-COUNTER-VALUE-FROM-C`

- SCOPE: INTERNAL
- LAMBDA LIST: `(NEW-VAL C-VAL)`
- SETF? `T`


<a name="api-function-compose-ns-fqn_429C7FEB5EDEF9F5BA148926B986BE2E"></a>
### FUNCTION: `%COMPOSE-NS-FQN`

- SCOPE: INTERNAL
- LAMBDA LIST: `(NS NAME)`
- SETF? `NIL`


<a name="api-function-tcl-ev-queue-cb-countervalue-from-c_FA0D11861888016B2A31C5236DD8C6F3"></a>
### FUNCTION: `%TCL-EV-QUEUE-CB-COUNTER/VALUE-FROM-C`

- SCOPE: INTERNAL
- LAMBDA LIST: `(C-VAL)`
- SETF? `NIL`


<a name="api-function-tcl-ev-queue-cb-countervalue-from-c_FA0D11861888016B2A31C5236DD8C6F3"></a>
### FUNCTION: `%TCL-EV-QUEUE-CB-COUNTER/VALUE-FROM-C`

- SCOPE: INTERNAL
- LAMBDA LIST: `(NEW-VAL C-VAL)`
- SETF? `T`


<a name="api-function-flags-bits_7D7D84CD232201E7DAD97CDC40E6F3F1"></a>
### FUNCTION: `->FLAGS-BITS*`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST ARGS)`
- SETF? `NIL`


<a name="api-function-flags-bits_3BFD46FDB58C30CAEEA3E21815BCE030"></a>
### FUNCTION: `->FLAGS-BITS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(FLAGS-LIST)`
- SETF? `NIL`


<a name="api-function-tcl-string-obj_90E47944DE749532AF4A1C9D860F2C9E"></a>
### FUNCTION: `->TCL-STRING-OBJ%`

- SCOPE: INTERNAL
- LAMBDA LIST: `(VAL)`
- SETF? `NIL`


<a name="api-function-tcl-string-obj_6F4E4F1FB8DF72A715E486DBF91F58FE"></a>
### FUNCTION: `->TCL-STRING-OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAL)`
- SETF? `NIL`


<a name="api-function-flags-bits_B3AA2DBDE26E2281CD14B8B55FE32C7F"></a>
### FUNCTION: `<-FLAGS-BITS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(FLAGS POSSIBLE-FLAGS)`
- SETF? `NIL`


<a name="api-function-tcl-int-bool_0F37E8C5223660286FF8C9905E52AC34"></a>
### FUNCTION: `<-TCL-INT-BOOL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INT-VAL)`
- SETF? `NIL`


<a name="api-function-aliasget_06FB3B5707003C3E1BC39DD827E4C285"></a>
### FUNCTION: `ALIAS/GET`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CHILD-CMD)`
- SETF? `NIL`


<a name="api-function-aliasobj_03F439710E33CFDBD7362BC03589AD15"></a>
### FUNCTION: `ALIAS/OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY CHILD-INTERP CHILD-CMD TGT-INTERP TGT-CMD TCL-OBJ-LIST-OBJV)`
- SETF? `NIL`


<a name="api-function-aliasstr_080C85487D4AA9CEB7C22143714771A2"></a>
### FUNCTION: `ALIAS/STR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY CHILD-INTERP CHILD-CMD TGT-INTERP TGT-CMD ARGV)`
- SETF? `NIL`


<a name="api-function-alist-tcl-dict_BB0C66EF329A1AA4CF19BAAB604EFE6E"></a>
### FUNCTION: `ALIST->TCL-DICT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP LST)`
- SETF? `NIL`


<a name="api-function-apply-lambda_8A7546D583FFE2ACC9F86267719083A2"></a>
### FUNCTION: `APPLY-LAMBDA`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCL-LAMBDA ARGS &KEY (RESULT-AS :STRING))`
- SETF? `NIL`


<a name="api-function-call-when-deletedadd_B22D396B5C8FDCB0B4FAF7ABAAEAE6C3"></a>
### FUNCTION: `CALL-WHEN-DELETED/+ADD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CLOSURE)`
- SETF? `NIL`

(CALL-WHEN-DELETED/+ADD closure) => client-data

<a name="api-function-call-when-deleted-del_5610DB497329F7995AD642E77B21E006"></a>
### FUNCTION: `CALL-WHEN-DELETED/-DEL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CLIENT-DATA)`
- SETF? `NIL`


<a name="api-function-call-when-deletedalloc-counter-cffi_1B4170644CC6DEB69E4F73DEFC3DEF0F"></a>
### FUNCTION: `CALL-WHEN-DELETED/ALLOC-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(&OPTIONAL INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-call-when-deletedcb_FCF110E326223A27750E938BCA15241A"></a>
### FUNCTION: `CALL-WHEN-DELETED/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-call-when-deletedcb_FCF110E326223A27750E938BCA15241A"></a>
### FUNCTION: `CALL-WHEN-DELETED/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE COUNTER)`
- SETF? `T`


<a name="api-function-call-when-deletedcounter-cffi_5F2931E782311E2364CC48E166A2BA6B"></a>
### FUNCTION: `CALL-WHEN-DELETED/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-call-when-deletedcounter-cffi_5F2931E782311E2364CC48E166A2BA6B"></a>
### FUNCTION: `CALL-WHEN-DELETED/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER COUNTER-PTR)`
- SETF? `T`


<a name="api-function-call-when-deleteddel-cb_7A560A81CF3AC9A17F391262B594C203"></a>
### FUNCTION: `CALL-WHEN-DELETED/DEL-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-call-when-deletedfree-counter-cffi_D53E81E0D847EFE01393D43796F02D6D"></a>
### FUNCTION: `CALL-WHEN-DELETED/FREE-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-call-when-deletedincr-count_8B7889F8772A1897FB9A24358DCECCDB"></a>
### FUNCTION: `CALL-WHEN-DELETED/INCR-COUNT`

- SCOPE: INTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-call-when-deletedregist-cb_4872E84FFEFDD4F6BE4C39775AE2381D"></a>
### FUNCTION: `CALL-WHEN-DELETED/REGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE)`
- SETF? `NIL`


<a name="api-function-call-when-deletedroute-by-client-data_9B6B901E0220A4A9F9C332B92A36B5F7"></a>
### FUNCTION: `CALL-WHEN-DELETED/ROUTE-BY-CLIENT-DATA`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA &REST ARGS)`
- SETF? `NIL`


<a name="api-function-call-when-deletedunregist-cb_C2682D8FDA6F2AFDAB7A7835949FB5C9"></a>
### FUNCTION: `CALL-WHEN-DELETED/UNREGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA)`
- SETF? `NIL`


<a name="api-function-chk-getset-var-as-type_D84D65322BA254C99AEFBEB25A9BAC65"></a>
### FUNCTION: `CHK-GET/SET-VAR-AS-TYPE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(AS)`
- SETF? `NIL`


<a name="api-function-cmd-infofree_7CE86BF8CD6EE142AC1E54EE9AB96411"></a>
### FUNCTION: `CMD-INFO/FREE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-INFO)`
- SETF? `NIL`


<a name="api-function-cmd-infofrom-cmd-obj_90D20C3B0CBFBCAD440B0DBFA4882104"></a>
### FUNCTION: `CMD-INFO/FROM-CMD-OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-OBJ)`
- SETF? `NIL`


<a name="api-function-cmd-infofrom-cmd-obj_90D20C3B0CBFBCAD440B0DBFA4882104"></a>
### FUNCTION: `CMD-INFO/FROM-CMD-OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NEW-CMD-INFO CMD-OBJ)`
- SETF? `T`


<a name="api-function-cmd-infofull-name_CA1A1A74F237C8F3ECA54A0B8D7C4827"></a>
### FUNCTION: `CMD-INFO/FULL-NAME`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-OBJ)`
- SETF? `NIL`


<a name="api-function-create-ensemble_D3A5E5B328375313EC151784FB130D4F"></a>
### FUNCTION: `CREATE-ENSEMBLE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NS-FQN ENSEMBLE-MAP-HT &KEY (INTERP *TCL-INTERP*))`
- SETF? `NIL`


<a name="api-function-create-obj-command_FE8CA501C9A0EF6F0962122420E4EF6C"></a>
### FUNCTION: `CREATE-OBJ-COMMAND`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP CMD-NAME FUNC)`
- SETF? `NIL`


<a name="api-function-create-string-command_0096EE9DB579073F1EC3C3DFAE173CC3"></a>
### FUNCTION: `CREATE-STRING-COMMAND`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP CMD-NAME FUNC)`
- SETF? `NIL`


<a name="api-function-def-cmdp_9480FC024D041FA820CCA366CF6FEF03"></a>
### FUNCTION: `DEF-CMD/P`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY (CMD-NAME "p"))`
- SETF? `NIL`


<a name="api-function-ensembleexclude_ABCE680CE846B2811BC2763A281AD85D"></a>
### FUNCTION: `ENSEMBLE/EXCLUDE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(ENSEMBLE-NAME)`
- SETF? `NIL`


<a name="api-function-ensembleinclude_6415BF0E9239013E94F13232BECC286F"></a>
### FUNCTION: `ENSEMBLE/INCLUDE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(ENSEMBLE-NAME &KEY CMD-FQN)`
- SETF? `NIL`


<a name="api-function-ensemblerename_F7776BD211CF39E6E448CF8433BF63D7"></a>
### FUNCTION: `ENSEMBLE/RENAME`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(FROM-ENSEMBLE &KEY TO-ENSEMBLE)`
- SETF? `NIL`


<a name="api-function-eval-tclstr_15D307888B21AA403BE5948E4D6D1040"></a>
### FUNCTION: `EVAL-TCL/STR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD)`
- SETF? `NIL`


<a name="api-function-eval-tcltcl-obj-list_38D7441FA433D57AF6B07E8C77BBEE6D"></a>
### FUNCTION: `EVAL-TCL/TCL-OBJ-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-LIST)`
- SETF? `NIL`

(list Tcl_Obj*)

<a name="api-function-eval-tcltcl-objv_789A16C7EC55076932FD543BAAABF1E2"></a>
### FUNCTION: `EVAL-TCL/TCL-OBJV`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(OBJV OBJC)`
- SETF? `NIL`

:tcl-objv (obj-count  Tcl_Obj**)

<a name="api-function-eval-tcltcl-string_8FB8B82AE186050302F19169E9426191"></a>
### FUNCTION: `EVAL-TCL/TCL-STRING`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD)`
- SETF? `NIL`

:tcl-string (Tcl_Obj*)

<a name="api-function-eval-tcl_DC3765A0EB21F760ADBD6F059A3BC2F1"></a>
### FUNCTION: `EVAL-TCL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST CMDS)`
- SETF? `NIL`


<a name="api-function-flags-bit_91FAE56118B55F8CD5CAEADAB96B801E"></a>
### FUNCTION: `FLAGS-BIT?`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NEEDLE HAYSTACK)`
- SETF? `NIL`


<a name="api-function-free-tcl-objv_EC574190EBD390E3102CB44A9568687F"></a>
### FUNCTION: `FREE-TCL-OBJV`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(OBJV-PTR)`
- SETF? `NIL`


<a name="api-function-get-varobj_0357AA3AD251EAA430D140E945CB6EC4"></a>
### FUNCTION: `GET-VAR/OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-get-varstr_F256B7EB898A5E1D9D490F73DAD9FC73"></a>
### FUNCTION: `GET-VAR/STR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-get-var_F90E54C20EB08DA104FCB9B0D274C8CA"></a>
### FUNCTION: `GET-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME &KEY ARRAY-SUBS (AS :STRING))`
- SETF? `NIL`


<a name="api-function-ht-tcl-dict_1DB382370423DC0B3869B9FD92B64E8A"></a>
### FUNCTION: `HT->TCL-DICT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP HT)`
- SETF? `NIL`


<a name="api-function-interp-tracetrace_D8D7B6FDBDAA24C324C6DED5C8CAC827"></a>
### FUNCTION: `INTERP-TRACE/+TRACE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CLOSURE &KEY (LEVEL +TCL-TRACE-LEVEL-ANY+)
 (FLAGS (->FLAGS-BITS* +TCL-ALLOW-INLINE-COMPILATION+)))`
- SETF? `NIL`


<a name="api-function-interp-trace-delete_678C61D91FB8E56BB7455E661DFE23A6"></a>
### FUNCTION: `INTERP-TRACE/-DELETE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TRACE)`
- SETF? `NIL`


<a name="api-function-interp-tracealloc-counter-cffi_FCD72476DA1641EFF7EFC2125B3047F2"></a>
### FUNCTION: `INTERP-TRACE/ALLOC-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(&OPTIONAL INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-interp-tracecb_00BF2063C858546642116F2240339F70"></a>
### FUNCTION: `INTERP-TRACE/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-interp-tracecb_00BF2063C858546642116F2240339F70"></a>
### FUNCTION: `INTERP-TRACE/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE COUNTER)`
- SETF? `T`


<a name="api-function-interp-tracecounter-cffi_8AE3588A11ED13BBD5E1BDC0CAF3C867"></a>
### FUNCTION: `INTERP-TRACE/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-interp-tracecounter-cffi_8AE3588A11ED13BBD5E1BDC0CAF3C867"></a>
### FUNCTION: `INTERP-TRACE/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER COUNTER-PTR)`
- SETF? `T`


<a name="api-function-interp-tracedel-cb_71BF5C5AE2741CDCE9E3552F271627A2"></a>
### FUNCTION: `INTERP-TRACE/DEL-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-interp-tracefree-counter-cffi_82F1CDC87645DE9FD7326AC50FD4CCA8"></a>
### FUNCTION: `INTERP-TRACE/FREE-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-interp-traceincr-count_E5C90DF50CE10994DF421DC658D6D31B"></a>
### FUNCTION: `INTERP-TRACE/INCR-COUNT`

- SCOPE: INTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-interp-traceregist-cb_6067E1C3C4A15B1A72E3ACAA3FA46E4F"></a>
### FUNCTION: `INTERP-TRACE/REGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE)`
- SETF? `NIL`


<a name="api-function-interp-traceroute-by-client-data_1F2E1E0A369104CB71878C83061B27C7"></a>
### FUNCTION: `INTERP-TRACE/ROUTE-BY-CLIENT-DATA`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA &REST ARGS)`
- SETF? `NIL`


<a name="api-function-interp-traceunregist-cb_B7CD17C1470D884E01ADB71193CBE202"></a>
### FUNCTION: `INTERP-TRACE/UNREGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA)`
- SETF? `NIL`


<a name="api-function-interpactive_94E5FB2683D3675FBBA8416C8CD5C38F"></a>
### FUNCTION: `INTERP/ACTIVE?`

- SCOPE: EXTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-interpchild_CD58C22B8EF6AF0D25A35233598D31F7"></a>
### FUNCTION: `INTERP/CHILD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CHILD-NAME)`
- SETF? `NIL`


<a name="api-function-interpcreate-child_3FA0D36BFEDAE757BB5719352F6E5A96"></a>
### FUNCTION: `INTERP/CREATE-CHILD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CHILD-NAME SAFE?)`
- SETF? `NIL`


<a name="api-function-interpdeleted_C6F4500F48C91059E6184A398A412D28"></a>
### FUNCTION: `INTERP/DELETED?`

- SCOPE: EXTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-interpexpose-cmd_8B4088CF57B04CAE8044E8E47EA06295"></a>
### FUNCTION: `INTERP/EXPOSE-CMD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(HIDDEN-CMD-NAME CMD-NAME)`
- SETF? `NIL`


<a name="api-function-interphide-cmd_27442766E6C9007C05186ADC27F6A3D1"></a>
### FUNCTION: `INTERP/HIDE-CMD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-NAME HIDDEN-CMD-NAME)`
- SETF? `NIL`


<a name="api-function-interpinterp-path_F443736D4FEB3A65FA6A3996482981C2"></a>
### FUNCTION: `INTERP/INTERP-PATH`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CHILD-INTERP)`
- SETF? `NIL`


<a name="api-function-interpparent_16CA562AAA8128F576841B2B03015990"></a>
### FUNCTION: `INTERP/PARENT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-interpsafe_0965176DEEEDDB6EE6A5D0F385695552"></a>
### FUNCTION: `INTERP/SAFE?`

- SCOPE: EXTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-linkarray_94107B1539BD67FFFD3FBBD6F1D1958B"></a>
### FUNCTION: `LINK/+ARRAY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(ARRAY-NAME VAR-TYPE SIZE &KEY READONLY? INITIAL-ELEMENT INITIAL-CONTENTS)`
- SETF? `NIL`


<a name="api-function-linkvar_69C66240D0A9CF34C3D556C4F50FB6ED"></a>
### FUNCTION: `LINK/+VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME VAR-TYPE &KEY READONLY? INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-link-unlink_6B260269B3A3CB233B5DED3FC58EABF7"></a>
### FUNCTION: `LINK/-UNLINK`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME)`
- SETF? `NIL`


<a name="api-function-linkalloc-array_BB6FD2438D4ACF001526703F3FF92C65"></a>
### FUNCTION: `LINK/ALLOC-ARRAY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-TYPE SIZE &KEY INITIAL-CONTENTS INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-linkalloc-var-str_1E5F72583D0FF93E332DE40F3162397D"></a>
### FUNCTION: `LINK/ALLOC-VAR-STR`

- SCOPE: INTERNAL
- LAMBDA LIST: `(INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-linkalloc-var_AE3C05E27A037306EEAFCEDF0838F526"></a>
### FUNCTION: `LINK/ALLOC-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-TYPE &KEY INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-linkarray-cffi-type_1C1C176EA96629EC2643298421D05C12"></a>
### FUNCTION: `LINK/ARRAY-CFFI-TYPE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(ARRAY-TYPE)`
- SETF? `NIL`


<a name="api-function-linkarray-type_DFD7F4A08A95680C150FF949168ADF17"></a>
### FUNCTION: `LINK/ARRAY-TYPE?`

- SCOPE: INTERNAL
- LAMBDA LIST: `(ARR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkcommon-type_14D338651C01BEA84700943C13B428A4"></a>
### FUNCTION: `LINK/COMMON-TYPE?`

- SCOPE: INTERNAL
- LAMBDA LIST: `(TYPE)`
- SETF? `NIL`


<a name="api-function-linkfree-array_C0955AFC6BF89CCCA5193D8E91C53E1E"></a>
### FUNCTION: `LINK/FREE-ARRAY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkfree-var-str_2CBF5B1B1B18840412CD1E2D4FA176DA"></a>
### FUNCTION: `LINK/FREE-VAR-STR`

- SCOPE: INTERNAL
- LAMBDA LIST: `(PTR)`
- SETF? `NIL`


<a name="api-function-linkfree-var_445141701991B4C607BD82C7CBFAF4AB"></a>
### FUNCTION: `LINK/FREE-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkread-array_04D3271675646175306C6858A0F2247B"></a>
### FUNCTION: `LINK/READ-ARRAY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE INDEX)`
- SETF? `NIL`


<a name="api-function-linkread-var-str_72071FFDA601EE3348309CD790228EF2"></a>
### FUNCTION: `LINK/READ-VAR-STR`

- SCOPE: INTERNAL
- LAMBDA LIST: `(PTR)`
- SETF? `NIL`


<a name="api-function-linkread-var_2047D6DBC351FE6A5C29659DB0B28090"></a>
### FUNCTION: `LINK/READ-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkupdate_6812AB85A4A3B7F0BCA2A741DD7BC3D8"></a>
### FUNCTION: `LINK/UPDATE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME)`
- SETF? `NIL`


<a name="api-function-linkvar-cffi-type_B02CEDE7C9748B5B15748648C26180EB"></a>
### FUNCTION: `LINK/VAR-CFFI-TYPE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(VAR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkvar-type_34FF36B6024887EEFE0762F025154481"></a>
### FUNCTION: `LINK/VAR-TYPE?`

- SCOPE: INTERNAL
- LAMBDA LIST: `(VAR-TYPE)`
- SETF? `NIL`


<a name="api-function-linkwrite-array_32904357253ED3410E4E138FDB53A583"></a>
### FUNCTION: `LINK/WRITE-ARRAY`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE INDEX NEW-VALUE)`
- SETF? `NIL`


<a name="api-function-linkwrite-var-str_2F61BF5DB3592ABE808DBA613CD83B96"></a>
### FUNCTION: `LINK/WRITE-VAR-STR`

- SCOPE: INTERNAL
- LAMBDA LIST: `(PTR NEW-VALUE)`
- SETF? `NIL`


<a name="api-function-linkwrite-var_4ADCDE5A6C6C848B18E39A73FEF4B21B"></a>
### FUNCTION: `LINK/WRITE-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(PTR VAR-TYPE NEW-VALUE)`
- SETF? `NIL`


<a name="api-function-lisp-bool-c-int_5006FFCE39DEE304EAE6F18D17655673"></a>
### FUNCTION: `LISP-BOOL->C-INT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAL)`
- SETF? `NIL`


<a name="api-function-lisp-value-or-nullptr_1B1D87DEC0EAEF9FC0CAB30A23357EB1"></a>
### FUNCTION: `LISP-VALUE-OR-NULLPTR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAL)`
- SETF? `NIL`


<a name="api-function-list-tcl-list_DD5023EBB9B299993C460D5F1A372F21"></a>
### FUNCTION: `LIST->TCL-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(LST)`
- SETF? `NIL`

(LIST lisp-value-1 tcl-obj-2 ... lisp-value-N) => (VALUES tcl-list tcl-list-length)

<a name="api-function-list-tcl-string-list_DF9F89B7B538CC4F6F8DCBA211C41097"></a>
### FUNCTION: `LIST->TCL-STRING-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(LST)`
- SETF? `NIL`

(LIST lisp-value-1 tcl-obj-2 ... lisp-value-N) => (LIST tcl-obj-1 tcl-obj-2 ... tcl-obj-N)

<a name="api-function-mnt-zipfs_4FD522735941AF5F638C7B662F6F59D3"></a>
### FUNCTION: `MNT-ZIPFS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(ZIP-FILENAME &KEY (MNT-POINT "//zipfs:/app") ZIP-PASSWD
 (TCL-LIBRARY-PATH "/tcl_library") (TK-LIBRARY-PATH "/tk_library"))`
- SETF? `NIL`


<a name="api-function-nullptr-nil_3863281E2BF50E6C20677107D5195126"></a>
### FUNCTION: `NULLPTR->NIL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CVAL)`
- SETF? `NIL`


<a name="api-function-objv-tcl-obj-list_3A79645A5F9ED721B7A838F1CD129336"></a>
### FUNCTION: `OBJV->TCL-OBJ-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(OBJC OBJV-PTR)`
- SETF? `NIL`


<a name="api-function-pack-tcl-error_6C604C87770565E469B9099BD6EE60AF"></a>
### FUNCTION: `PACK-TCL-ERROR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST ARGS &KEY (CONDITION '<TCL-ERROR>) (THROW? *DO+CHK/ERROR?*)
 &ALLOW-OTHER-KEYS)`
- SETF? `NIL`


<a name="api-function-queue-evt-func_E2B986AC3E80DFF0F3C9339CA2086000"></a>
### FUNCTION: `QUEUE-EVT-FUNC`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY INTERP THREAD-ID EV-QUEUE-CB-FDEF (QUEUE-POSITION :TCL-QUEUE-TAIL)
 (THREAD-ALERT-P T))`
- SETF? `NIL`


<a name="api-function-remhash-by-value_8042B598E655FFC9F1A417EC07306816"></a>
### FUNCTION: `REMHASH-BY-VALUE`

- SCOPE: INTERNAL
- LAMBDA LIST: `(VAL HT &KEY (TEST #'EQ))`
- SETF? `NIL`


<a name="api-function-result-as_30C1DDB3C198AC4541BBC94D1BC4D26B"></a>
### FUNCTION: `RESULT-AS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(RESULT-AS)`
- SETF? `NIL`


<a name="api-function-set-tcl-result-from-error_E64D65F1BB7831963D0990CC364198FE"></a>
### FUNCTION: `SET-TCL-RESULT-FROM-ERROR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(AN-ERROR)`
- SETF? `NIL`


<a name="api-function-set-tcl-result-string_82AE2AA171037E491DCE4200B2435590"></a>
### FUNCTION: `SET-TCL-RESULT-STRING`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(S)`
- SETF? `NIL`


<a name="api-function-set-varobj_F4E90A5DD13E210B4ABDBAEC2FCC9AB1"></a>
### FUNCTION: `SET-VAR/OBJ`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME NEW-VAL &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-set-varstr_B45580CA72A8BD8B5524A2998B2FF406"></a>
### FUNCTION: `SET-VAR/STR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME NEW-VAL &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-set-var_C6C86F9D0DF4F9102C07EE63901F56B8"></a>
### FUNCTION: `SET-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME NEW-VAL &KEY ARRAY-SUBS (AS :STRING))`
- SETF? `NIL`


<a name="api-function-str-tcl-alloced-charp_D38EF3E40511C2DC04EC2DBD4886A91C"></a>
### FUNCTION: `STR->TCL-ALLOCED-CHARP`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(S)`
- SETF? `NIL`


<a name="api-function-tcl-ns_7B3139E774070EDA6B2C54ADFFDC6C8F"></a>
### FUNCTION: `TCL-NS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NS-FQN &KEY EXPORTS (INTERP *TCL-INTERP*))`
- SETF? `NIL`


<a name="api-function-tcl-obj-list-objv_655BF97466CF5566084893EE3A2FA6B5"></a>
### FUNCTION: `TCL-OBJ-LIST->OBJV`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(TCL-OBJ-LIST)`
- SETF? `NIL`

(LIST tcl-obj-1 ... tcl-obj-N) => Tcl_Obj*[]

<a name="api-function-tcl-obj-list-tcl-list_285C3F25B208855EE68DB14CC463AA0A"></a>
### FUNCTION: `TCL-OBJ-LIST->TCL-LIST`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(OBJ-LIST)`
- SETF? `NIL`

(LIST tcl-obj-1 ... tcl-obj-N) => (VALUES tcl-list tcl-list-length)

<a name="api-function-tcl-result-as-error_88480C0DF132A646905B1B4F527C284A"></a>
### FUNCTION: `TCL-RESULT-AS-ERROR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST ARGS)`
- SETF? `NIL`


<a name="api-function-trace-cmdtrace_A74A697127FE7F50B669C348BE519E1D"></a>
### FUNCTION: `TRACE-CMD/+TRACE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-NAME CLOSURE &KEY (FLAGS 0))`
- SETF? `NIL`


<a name="api-function-trace-cmd-untrace_D1FF9780487CED9AFF989FF3D0670577"></a>
### FUNCTION: `TRACE-CMD/-UNTRACE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-NAME CLIENT-DATA &KEY (FLAGS 0))`
- SETF? `NIL`


<a name="api-function-trace-cmdalloc-counter-cffi_1ED83E061D46AD631544E009CDBBF22A"></a>
### FUNCTION: `TRACE-CMD/ALLOC-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(&OPTIONAL INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-trace-cmdcb_3FE51CE702D402C51C03031857C24578"></a>
### FUNCTION: `TRACE-CMD/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-trace-cmdcb_3FE51CE702D402C51C03031857C24578"></a>
### FUNCTION: `TRACE-CMD/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE COUNTER)`
- SETF? `T`


<a name="api-function-trace-cmdcounter-cffi_3E1C13DB638FB35861BAF72607901181"></a>
### FUNCTION: `TRACE-CMD/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-trace-cmdcounter-cffi_3E1C13DB638FB35861BAF72607901181"></a>
### FUNCTION: `TRACE-CMD/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER COUNTER-PTR)`
- SETF? `T`


<a name="api-function-trace-cmddel-cb_6903975216C1C6AD47316A6C285CD7D0"></a>
### FUNCTION: `TRACE-CMD/DEL-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-trace-cmdenforce-flags_51F48548CA364778AEFA84DDD54F3684"></a>
### FUNCTION: `TRACE-CMD/ENFORCE-FLAGS`

- SCOPE: INTERNAL
- LAMBDA LIST: `(FLAGS)`
- SETF? `NIL`


<a name="api-function-trace-cmdfree-counter-cffi_A1EBA48195236397ECA702B610C6305A"></a>
### FUNCTION: `TRACE-CMD/FREE-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-trace-cmdincr-count_511C829ABA0981FB79DFBB42E60EB907"></a>
### FUNCTION: `TRACE-CMD/INCR-COUNT`

- SCOPE: INTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-trace-cmdlist-all_7FCA16F23F467EAEAEE5A57B9A0C6B9F"></a>
### FUNCTION: `TRACE-CMD/LIST-ALL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(CMD-NAME)`
- SETF? `NIL`


<a name="api-function-trace-cmdregist-cb_9F6889831983909E450098554BEEC2F3"></a>
### FUNCTION: `TRACE-CMD/REGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE)`
- SETF? `NIL`


<a name="api-function-trace-cmdroute-by-client-data_1805925E9D5932ACBB52963BCD4866A1"></a>
### FUNCTION: `TRACE-CMD/ROUTE-BY-CLIENT-DATA`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA &REST ARGS)`
- SETF? `NIL`


<a name="api-function-trace-cmdunregist-cb_85793B3F4C507325D02304C333B4BB4E"></a>
### FUNCTION: `TRACE-CMD/UNREGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA)`
- SETF? `NIL`


<a name="api-function-trace-vartrace_FD4C78E3F753B0E629DB1DC6216D9E97"></a>
### FUNCTION: `TRACE-VAR/+TRACE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME CLOSURE &KEY (FLAGS 0) ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-trace-var-untrace_4749EE47F32C5F11F64DD33F5DBBA95D"></a>
### FUNCTION: `TRACE-VAR/-UNTRACE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME CLIENT-DATA &KEY (FLAGS 0) ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-trace-varalloc-counter-cffi_657CE1763F4B24307130582C09CD4BB9"></a>
### FUNCTION: `TRACE-VAR/ALLOC-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(&OPTIONAL INITIAL-ELEMENT)`
- SETF? `NIL`


<a name="api-function-trace-varcb_B8A251862B5183F311A0C183618563E3"></a>
### FUNCTION: `TRACE-VAR/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-trace-varcb_B8A251862B5183F311A0C183618563E3"></a>
### FUNCTION: `TRACE-VAR/CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE COUNTER)`
- SETF? `T`


<a name="api-function-trace-varcounter-cffi_D9D037D8E0040EAE39CFA4A3EDB59226"></a>
### FUNCTION: `TRACE-VAR/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-trace-varcounter-cffi_D9D037D8E0040EAE39CFA4A3EDB59226"></a>
### FUNCTION: `TRACE-VAR/COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER COUNTER-PTR)`
- SETF? `T`


<a name="api-function-trace-vardel-cb_42B2070C1B7899ED7A13D44390915018"></a>
### FUNCTION: `TRACE-VAR/DEL-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER)`
- SETF? `NIL`


<a name="api-function-trace-varenforce-flags_495585F9E5A99BD789071E66BB7A141E"></a>
### FUNCTION: `TRACE-VAR/ENFORCE-FLAGS`

- SCOPE: INTERNAL
- LAMBDA LIST: `(FLAGS)`
- SETF? `NIL`


<a name="api-function-trace-varfree-counter-cffi_E947301BDE5CE35DBF7029D89AFC3901"></a>
### FUNCTION: `TRACE-VAR/FREE-COUNTER-CFFI`

- SCOPE: INTERNAL
- LAMBDA LIST: `(COUNTER-PTR)`
- SETF? `NIL`


<a name="api-function-trace-varincr-count_981775BC97B5F50E09F258A39D1E137B"></a>
### FUNCTION: `TRACE-VAR/INCR-COUNT`

- SCOPE: INTERNAL
- LAMBDA LIST: `NIL`
- SETF? `NIL`


<a name="api-function-trace-varlist-all_5955F243F0BFBAE07CF1A7B43AF156FB"></a>
### FUNCTION: `TRACE-VAR/LIST-ALL`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-trace-varregist-cb_6D9220B40DCF2477330E80CD56ABE675"></a>
### FUNCTION: `TRACE-VAR/REGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLOSURE)`
- SETF? `NIL`


<a name="api-function-trace-varroute-by-client-data_138D9A8ABE0AEAFBF46AC5DF354783E8"></a>
### FUNCTION: `TRACE-VAR/ROUTE-BY-CLIENT-DATA`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA &REST ARGS)`
- SETF? `NIL`


<a name="api-function-trace-varunregist-cb_6407E8AFF00CB0485E358492444EC6E5"></a>
### FUNCTION: `TRACE-VAR/UNREGIST-CB`

- SCOPE: INTERNAL
- LAMBDA LIST: `(CLIENT-DATA)`
- SETF? `NIL`


<a name="api-function-umnt-zipfs_05D029300A736BCC96C13FE6C811F3CE"></a>
### FUNCTION: `UMNT-ZIPFS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY (MNT-POINT "//zipfs:/app"))`
- SETF? `NIL`


<a name="api-function-unset-var_C3F36293AD59CD0AB54EB68603D03117"></a>
### FUNCTION: `UNSET-VAR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(VAR-NAME &KEY ARRAY-SUBS)`
- SETF? `NIL`


<a name="api-function-wrap-error_2EB742DBF7465D81D1226715555B963B"></a>
### FUNCTION: `WRAP-ERROR*`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP ERR)`
- SETF? `NIL`


<a name="api-function-wrap-error_740EB6BA24804D761A0786F661F71744"></a>
### FUNCTION: `WRAP-ERROR`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP ERR)`
- SETF? `NIL`


<a name="api-function-wrap-result_BD90A9735958013B7DA9E33B6794197C"></a>
### FUNCTION: `WRAP-RESULT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP VAL)`
- SETF? `NIL`


<a name="api-macro-defun-create-command_3671337BCC6B101FFC4EB45D517AD8BE"></a>
### MACRO: `%DEFUN-CREATE-COMMAND`

- SCOPE: INTERNAL
- LAMBDA LIST: `(DEFUN-NAME
 (&KEY FRLOCK COUNTER CB-HT CMD-PROC-CB (CMD-DEL-CB '%TCL-CMD-DELETE-PROC-CB)
  TCL-CREATE-COMMAND-FN))`
- SETF? `NIL`

`defun-name'으로 create-command* 하는 함수를 등록.

그 함수는 `(interp cmd-name func) => (cons cmd-nr tcl-command-ptr)'

func은 `(interp args) => int'. 리턴값은 +tcl-ok+ / +tcl-error+.

<a name="api-macro-tcl-cmd-proc-cffi-callback-body_583D31DBEA5426DB7BA4532EB1DEBE51"></a>
### MACRO: `%TCL-CMD-PROC-CFFI-CALLBACK-BODY`

- SCOPE: INTERNAL
- LAMBDA LIST: `(&KEY VAR-INTERP VAR-ARGC VAR-ARGV FRLOCK CB-HT ARGC+ARGV-CVTER)`
- SETF? `NIL`


<a name="api-macro-app-main_96B26B543F313711FC65BF84B4E8D15A"></a>
### MACRO: `APP-MAIN`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((&KEY (DO+CHK/ERROR? T) (TCL-CREATE-INTERP '(TCL-CREATE-INTERP))
  TCL-INIT-SUBSYSTEMS? TK-INIT? TK-MAIN-LOOP? ZIP-FILENAME ZIP-PASSWD
  (ZIPFS-MNT-POINT "//zipfs:/app") (ZIPFS-TCL-LIBRARY-PATH "/tcl_library")
  (ZIPFS-TK-LIBRARY-PATH "/tk_library") BEFORE-CREATE-INTERP BEFORE-INIT
  AFTER-INIT BEFORE-DEINIT AFTER-DEINIT STDOUT-STREAM STDERR-STREAM
  (TERMINATE-WITHOUT-DEINIT NIL))
 &REST BODY)`
- SETF? `NIL`


<a name="api-macro-def-cmd_A944F19F7D14711CA81C5E1856F940D3"></a>
### MACRO: `DEF-CMD`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((NAME &KEY (INTERP '*TCL-INTERP*) (LAMBDA-LIST '(INTERP ARGS))
  (ARGS-TYPE :STRINGS) (NS '*DEF-CMD-NS*) (WRAP-P T))
 &REST BODY)`
- SETF? `NIL`


<a name="api-macro-def-ensemble_89A74F29323FAFDDE57F72F41762FDE2"></a>
### MACRO: `DEF-ENSEMBLE`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((NS-FQN &KEY (INTERP '*TCL-INTERP*)) &REST BODY)`
- SETF? `NIL`


<a name="api-macro-def-tcl-callback-pattern_F73B15D6F4F58D1579444E922A276C7A"></a>
### MACRO: `DEF-TCL-CALLBACK-PATTERN`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&KEY CB-PREFIX ONE-OFF? (COUNTER-CFFI-TYPE :UINT64)
 (CLOSURE-MAP-INITFORM '(MAKE-HASH-TABLE)))`
- SETF? `NIL`


<a name="api-macro-dochk_F2D2ED544BF1962D1CAEABE423F3245B"></a>
### MACRO: `DO+CHK`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((FN-NAME &KEY (INTERP '*TCL-INTERP*) (TCL-OK +TCL-OK+)
  (ERROR? '*DO+CHK/ERROR?*) (INCLUDE-ERROR-INFO? T))
 &REST ARGS)`
- SETF? `NIL`


<a name="api-macro-nconcf-if_5E5B27D99B6CE44FE13D6D1517DCBE85"></a>
### MACRO: `NCONCF-IF`

- SCOPE: INTERNAL
- LAMBDA LIST: `(PLACE PRED-FORM LIST-TO-NCONC)`
- SETF? `NIL`


<a name="api-macro-queue-evt_AA149FB6F9FB0D8BB5232AF43738430C"></a>
### MACRO: `QUEUE-EVT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((&REST FWD-OPTS &KEY (CB-RETURN-CODE 1)
  (LAMBDA-LIST '(INTERP THREAD-ID CB-COUNTER)) &ALLOW-OTHER-KEYS)
 &REST BODY)`
- SETF? `NIL`


<a name="api-macro-track-def-cmds_7B2DAFF84BA57FD399D2FEAEC46B6586"></a>
### MACRO: `TRACK-DEF-CMDS`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST BODY)`
- SETF? `NIL`


<a name="api-macro-with-cmd-info_A8DC4811B0B3BBA57B08B14BBE61C7F5"></a>
### MACRO: `WITH-CMD-INFO`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((&KEY V-CMD-INFO CMD-OBJ MODIFY?) &REST BODY)`
- SETF? `NIL`


<a name="api-macro-with-interp_92FA276533D47FA30402607B0E838E22"></a>
### MACRO: `WITH-INTERP`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(INTERP &REST BODY)`
- SETF? `NIL`


<a name="api-macro-with-tcl-errorresult_076A9135EE5C56C72F959364B080AA52"></a>
### MACRO: `WITH-TCL-ERROR/RESULT`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST BODY)`
- SETF? `NIL`


<a name="api-macro-with-tcl-errorthrown_7B7AE1A6816A3A54C8E401950286D44F"></a>
### MACRO: `WITH-TCL-ERROR/THROWN`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(&REST BODY)`
- SETF? `NIL`


<a name="api-macro-with-tcl-objv_126AB448CDEC71DD3AFFC9B1C41E6E1F"></a>
### MACRO: `WITH-TCL-OBJV`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((LST &KEY (V-TCL-OBJV 'TCL-OBJV) (V-TCL-OBJC 'TCL-OBJC)) &REST BODY)`
- SETF? `NIL`


<a name="api-method-destroy-arr-link-tcl-array-link_D7BA1527057A08AE895D0C48ED370B10"></a>
### METHOD: `DESTROY` `((ARR-LINK <TCL-ARRAY-LINK>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((ARR-LINK <TCL-ARRAY-LINK>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-destroy-var-link-tcl-var-link_8686687800D7ECD054FA799561558900"></a>
### METHOD: `DESTROY` `((VAR-LINK <TCL-VAR-LINK>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((VAR-LINK <TCL-VAR-LINK>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-linked-value-at-arr-link-tcl-array-link-index_E611DDD7F1DA85A057ACF311BFA45217"></a>
### METHOD: `LINKED-VALUE-AT` `((ARR-LINK <TCL-ARRAY-LINK>) INDEX)`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((ARR-LINK <TCL-ARRAY-LINK>) INDEX)`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-linked-value-at-new-value-arr-link-tcl-array-link-index_2A7EE1EA44DD62B34B5F948CFF8C8712"></a>
### METHOD: `LINKED-VALUE-AT` `(NEW-VALUE (ARR-LINK <TCL-ARRAY-LINK>) INDEX)`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NEW-VALUE (ARR-LINK <TCL-ARRAY-LINK>) INDEX)`
- SETF? `T`
- QUALIFIERS: `NIL`


<a name="api-method-linked-value-var-link-tcl-var-link_D10344D5AEDDD624B90B7D61A61D6ECF"></a>
### METHOD: `LINKED-VALUE` `((VAR-LINK <TCL-VAR-LINK>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((VAR-LINK <TCL-VAR-LINK>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-linked-value-new-value-var-link-tcl-var-link_7F781FD6C8984B6F0658EC2CBBED0BE1"></a>
### METHOD: `LINKED-VALUE` `(NEW-VALUE (VAR-LINK <TCL-VAR-LINK>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `(NEW-VALUE (VAR-LINK <TCL-VAR-LINK>))`
- SETF? `T`
- QUALIFIERS: `NIL`


<a name="api-method-untrace-cmd-cmd-trace-tcl-cmd-trace_FDC117D5840D3AD4952344F5044AA884"></a>
### METHOD: `UNTRACE-CMD` `((CMD-TRACE <TCL-CMD-TRACE>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((CMD-TRACE <TCL-CMD-TRACE>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-untrace-var-var-trace-tcl-var-trace_00B6504FF831ADB80FE5EB8B0B633603"></a>
### METHOD: `UNTRACE-VAR` `((VAR-TRACE <TCL-VAR-TRACE>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((VAR-TRACE <TCL-VAR-TRACE>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-method-update-var-link-tcl-var-link-base_5B86EC8A9BD7D8B4F2F4D2BD61F21B4F"></a>
### METHOD: `UPDATE` `((VAR-LINK <TCL-VAR-LINK-BASE>))`

- SCOPE: EXTERNAL
- LAMBDA LIST: `((VAR-LINK <TCL-VAR-LINK-BASE>))`
- SETF? `NIL`
- QUALIFIERS: `NIL`


<a name="api-variable-call-when-deleted-cb-counter_6B63968B507AEA6574EF18A50A1EDC9C"></a>
### VARIABLE: `*CALL-WHEN-DELETED-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-call-when-deleted-cb-ht_870AB83210232DE593AC0C7EBD2BD0AF"></a>
### VARIABLE: `*CALL-WHEN-DELETED-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-call-when-deleted-cb-lock_89AD5D11001C4953396FB6B27F2DB57F"></a>
### VARIABLE: `*CALL-WHEN-DELETED-CB-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*call-when-deleted-cb-lock*")`


<a name="api-variable-def-cmd-ns_A34D0EA43D7AEF6B28059317E9292905"></a>
### VARIABLE: `*DEF-CMD-NS*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `""`


<a name="api-variable-def-cmd-tracker_DD0D1C8B76825CCC9B9E66FE68F34DAA"></a>
### VARIABLE: `*DEF-CMD-TRACKER*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `NIL`


<a name="api-variable-def-cmd-tracking-ht_89C9B1E27A5ADA42AF3266AA769F03E6"></a>
### VARIABLE: `*DEF-CMD-TRACKING-HT*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-dochkerror_9F794C1DCE6D7E141473980FDF2F1261"></a>
### VARIABLE: `*DO+CHK/ERROR?*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `T`


<a name="api-variable-interp-trace-cb-counter_F09D08235BD24B699B06B4BFFA522473"></a>
### VARIABLE: `*INTERP-TRACE-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-interp-trace-cb-ht_E1EE036F30E3977FF446BC5084E6549F"></a>
### VARIABLE: `*INTERP-TRACE-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-interp-trace-cb-lock_DBD1664C50B8D614E0C672CBD66B8AEB"></a>
### VARIABLE: `*INTERP-TRACE-CB-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*interp-trace-cb-lock*")`


<a name="api-variable-stringify-for-tcl-obj-func_A050BCAF4C8FAE7ED2E4C23D4A86A311"></a>
### VARIABLE: `*STRINGIFY-FOR-TCL-OBJ-FUNC*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `(LAMBDA (V) (FORMAT NIL "~a" V))`


<a name="api-variable-tcl-cmd-cb-counter_C9D8FB2966F564F742A286F2EB0F13A9"></a>
### VARIABLE: `*TCL-CMD-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-tcl-cmd-lock_E6AA155E1AE3420E3B198104330CC981"></a>
### VARIABLE: `*TCL-CMD-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*tcl-cmd-lock*")`


<a name="api-variable-tcl-cmd-obj-cb-ht_38B647D19321E53171842EE1D5AC73EE"></a>
### VARIABLE: `*TCL-CMD-OBJ-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-tcl-cmd-string-cb-ht_9A59C79E489AD25D4524BD272A7D0257"></a>
### VARIABLE: `*TCL-CMD-STRING-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-tcl-ev-queue-cb-counter_CDA163123E7E5E7FFF1BB687F71D1121"></a>
### VARIABLE: `*TCL-EV-QUEUE-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-tcl-ev-queue-cb-ht_8E2952BD242D829A07EDE11EAF91FA12"></a>
### VARIABLE: `*TCL-EV-QUEUE-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-tcl-ev-queue-lock_64ADE4DDCA4E36E0E4A35B14565B677F"></a>
### VARIABLE: `*TCL-EV-QUEUE-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*tcl-ev-queue-lock*")`


<a name="api-variable-tcl-interp_F6FB251E08DFDAA91F1BBB1856099374"></a>
### VARIABLE: `*TCL-INTERP*`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `NIL`


<a name="api-variable-trace-cmd-cb-counter_5E34F48C2BB8201F2663D16ECE023CBA"></a>
### VARIABLE: `*TRACE-CMD-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-trace-cmd-cb-ht_093BD5DB8A2B5443309707FB27D18BB3"></a>
### VARIABLE: `*TRACE-CMD-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-trace-cmd-cb-lock_8FD316EF3455AFEA34EAFD535E5844FC"></a>
### VARIABLE: `*TRACE-CMD-CB-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*trace-cmd-cb-lock*")`


<a name="api-variable-trace-var-cb-counter_7130538A735388A0016442A4D664388C"></a>
### VARIABLE: `*TRACE-VAR-CB-COUNTER*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-trace-var-cb-ht_0550D95E2AAB9BAA6C76844B314961E0"></a>
### VARIABLE: `*TRACE-VAR-CB-HT*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(MAKE-HASH-TABLE)`


<a name="api-variable-trace-var-cb-lock_C56BA92D08965F7DD7BBA61A1A21DB74"></a>
### VARIABLE: `*TRACE-VAR-CB-LOCK*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(BT2:MAKE-LOCK :NAME "*trace-var-cb-lock*")`


<a name="api-variable-var-flags_834701E53627F1D07EED3985B82FDEF8"></a>
### VARIABLE: `*VAR-FLAGS*`

- SCOPE: INTERNAL
- INITIAL-VALUE: `+TCL-LEAVE-ERR-MSG+`


<a name="api-variable-linkarray-cffi-type-plist_797B035A60F41D1E73CD27831070C547"></a>
### VARIABLE: `+LINK/ARRAY-CFFI-TYPE-PLIST+`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(APPEND +LINK/COMMON-CFFI-TYPE-PLIST+
        (LIST +TCL-LINK-BINARY+ :UCHAR +TCL-LINK-CHARS+ :CHAR))`


<a name="api-variable-linkcommon-cffi-type-plist_88E61685C0D7E52AEEDAB11427F1F409"></a>
### VARIABLE: `+LINK/COMMON-CFFI-TYPE-PLIST+`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(LIST +TCL-LINK-INT+ :INT +TCL-LINK-UINT+ :UINT +TCL-LINK-CHAR+ :CHAR
      +TCL-LINK-UCHAR+ :UCHAR +TCL-LINK-SHORT+ :SHORT +TCL-LINK-USHORT+ :USHORT
      +TCL-LINK-LONG+ :LONG +TCL-LINK-ULONG+ :ULONG +TCL-LINK-WIDE-INT+
      :TCL-WIDE-INT +TCL-LINK-WIDE-UINT+ :TCL-WIDE-UINT +TCL-LINK-FLOAT+ :FLOAT
      +TCL-LINK-DOUBLE+ :DOUBLE +TCL-LINK-BOOLEAN+ :BOOLEAN)`


<a name="api-variable-linkvar-cffi-type-plist_D65D6EB27D8BB737044E1DD305CDE2E0"></a>
### VARIABLE: `+LINK/VAR-CFFI-TYPE-PLIST+`

- SCOPE: INTERNAL
- INITIAL-VALUE: `(APPEND +LINK/COMMON-CFFI-TYPE-PLIST+
        (LIST +TCL-LINK-STRING+ '(:POINTER :CHAR)))`


<a name="api-variable-tcl-trace-level-any_CCE42BCE5D2F56E6E7CFD46E04AB150E"></a>
### VARIABLE: `+TCL-TRACE-LEVEL-ANY+`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `0`


<a name="api-variable-tcl-trace-level-only-top_922CDE5F62BE416843089983CCD7457B"></a>
### VARIABLE: `+TCL-TRACE-LEVEL-ONLY-TOP+`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `1`


<a name="api-variable-tcl-trace-level-only-top-and-one-more_B9F9FE57B007992AF82A62549D67CA3E"></a>
### VARIABLE: `+TCL-TRACE-LEVEL-ONLY-TOP-AND-ONE-MORE+`

- SCOPE: EXTERNAL
- INITIAL-VALUE: `2`


--------------------------------
Generated with [doqumen](https://github.com/ageldama/doqumen/) at 2026-05-19T00:04:52.302276+09:00 by https://github.com/ageldama
