------------------------------------------------------------------------------
--  ▄▖▄▖▄ ▄▖
--  ▌▌▐ ▌▌▙▖
--  ▛▌▟▖▙▘▙▖
--
--  @file      aide-srv.adb
--  @copyright Sowebio SARL - France
--  @licence   GPL v3
--  @encoding  UTF-8
------------------------------------------------------------------------------
--  @summary
--  AIDE - Ada Instant Develoment Environment for Debian/Ubuntu & derivatives
--
--  @description
--  Service procedures and functions
--
--  @authors
--  Stéphane Rivière - sr - sriviere@soweb.io
--
--  @versions
--  see aide.adb
------------------------------------------------------------------------------

separate (Aide) package body Srv is

   ----------------------------------------------------------------------------
   procedure Install_Registering (Year_Install : VString) is

      pragma Style_Checks (Off); -- Can't strip columns
   
      SE_Result : Integer := 0;
      SE_Output : VString := +"";
      LF : constant VString := To_VString (Character'Val (10));
      DQ : constant VString := To_VString (Character'Val (34));
      File_Handle : Tio.File;
      File_Content : VString := +"";
      GPS_Icon_File : VString := +"";
      GPS_Exec_Name : VString := +"";
      GPS_StartupWMClass : VString := +"";
      Databases_Update_Needed : Boolean := False;
      Check_File_Name : constant VString := Sys.Get_Home & "/check.gpr";
      Mime_Application_Type : constant VString := Mime_Application & "/" & Mime_Type ;
      
      Desktop_File_Name : constant VString := Sys.Get_Home & "/.local/share/applications/gps" & Year_Install & ".desktop";
      Desktop_File_Name_Old_1 : constant VString := Sys.Get_Home & "/.local/share/applications/gps.desktop";   
      Desktop_File_Name_Old_2 : constant VString := Sys.Get_Home & "/.local/share/applications/gnatstudio.desktop";                                   
   begin
   
      --  No need to register in server mode
      if GNAT_Target = "server" then
         Log.Msg (+"Server target: no need to register.");  
         return;
      end if;
      
      --  https://help.gnome.org/admin/system-admin-guide/stable/mime-types-custom-user.html.en

      --  Mime type
      if not Fls.Exists (Mime_Type_Package_Name) then

         Log.Msg (+"Generating MIME Type file.");
         
         if Fls.Create_Directory_Tree (Sys.Get_Home & "/.local/share/mime/packages") then
         
            File_Content :=
            +"<?xml version=" & DQ & "1.0" & DQ & " encoding=" & DQ & "UTF-8" & DQ & "?>" & LF &
            "<mime-info xmlns=" & DQ & "http://www.freedesktop.org/standards/shared-mime-info" & DQ & ">" & LF &
            "  <mime-type type=" & DQ & "application/x-adagpr" & DQ & ">" & LF & 
            "    <comment>GNAT Gprbuild file</comment>" & LF &
            "    <glob pattern=" & DQ & "*.gpr" & DQ & "/>" & LF &
            "  </mime-type>" & LF &
            "</mime-info>";
         
            Tio.Create (File_Handle, Mime_Type_Package_Name);
            Tio.Put_Line (File_Handle, File_Content);  
            Tio.Close (File_Handle);
            
            Databases_Update_Needed := True;
         else
            Log.Err ("Install_Registering - Can't create: " & Sys.Get_Home & "/.local/share/mime/packages"); 
         end if;
      else
         Log.Msg (+"MIME Type file already created.");  
      end if;
      
      --  Clean old launchers without a year in filename
      Fls.Delete_File (Desktop_File_Name_Old_1);
      Fls.Delete_File (Desktop_File_Name_Old_2); 
     
      -- Launcher   
      if not Fls.Exists (Desktop_File_Name) then
         
         Log.Msg (+"Generating GPS launcher file.");
         
         if Fls.Create_Directory_Tree (Sys.Get_Home & "/.local/share/applications") then
         
            if (Year_Install = "2019") then
               GPS_Icon_File := +"/share/gps/icons/hicolor/32x32/apps/gps_welcome_logo.png";
               GPS_Exec_Name := +"/bin/gps";
               GPS_StartupWMClass := +"gps_exe";
            elsif (Year_Install = "2020") or 
                  (Year_Install = "2021") then
               GPS_Icon_File := +"/share/gnatstudio/icons/hicolor/32x32/apps/gnatstudio_logo.png";
               GPS_Exec_Name := +"/bin/gnatstudio";
               GPS_StartupWMClass := +"gnatstudio_exe";
            end if;
         
            File_Content :=
            +"[Desktop Entry]" & LF &
            "Name=Gnat Programming System " & Year_Install & LF &
            "Icon=" & GNAT_Dir & GPS_Icon_File & LF & 
            "Exec=" & GNAT_Dir & GPS_Exec_Name & LF &
            "Terminal=false" & LF &
            "Type=Application" & LF &
            "MimeType=" & Mime_Application_Type & LF &
            "Categories=Development;" & LF &
            "StartupWMClass=" & GPS_StartupWMClass;
         
            Tio.Create (File_Handle, Desktop_File_Name);
            Tio.Put_Line (File_Handle, File_Content);  
            Tio.Close (File_Handle);
         
            Databases_Update_Needed := True;
         else
            Log.Err ("Install_Registering - Can't create: " & Sys.Get_Home & "/.local/share/applications"); 
         end if;
      else
         Log.Msg (+"GPS launcher already created.");  
      end if;
      
      --  Check_File_Name        : /home/sr/check.gpr
      --  Desktop_File_Name      : /home/sr/.local/share/applications/gps20**.desktop
      --  Mime_Application       : application
      --  Mime_Application_Type  : application/x-adagpr
      --  Mime_Type              : x-adagpr
      --  Mime_Type_Package_Name : /home/sr/.local/share/mime/packages/application-x-adagpr.xml
      
      if Databases_Update_Needed then
         
         Log.Msg (+"Updating MIME and Desktop databases.");
         
         --  update-mime-database /home/sr/.local/share/mime
         Sys.Shell_Execute (+"update-mime-database " & Sys.Get_Home & "/.local/share/mime");
         
         --  update-desktop-database /home/sr/.local/share/applications
         Sys.Shell_Execute (+"update-desktop-database " & Sys.Get_Home & "/.local/share/applications");
         
         Log.Msg (+"Check .gpr assoc. with " & Mime_Application_Type & " MIME type.");
         
         Tio.Create (File_Handle, Check_File_Name);
         Tio.Close (File_Handle);
         
         if Fls.Exists (Check_File_Name) then
                  
            --  Irrelevant test, allways output: content-type: text/plain
            --  gio info /home/sr/check.gpr | grep "standard::content-type"
            --  Sys.Shell_Execute (+"gio info " & Check_File_Name & 
            --                   " | grep " & DQ & 
            --                   "standard::content-type" & DQ, 
            --                   SE_Result,
            --                   SE_Output);
            --  if Log.Get_Debug then
            --     Log.Dbg (SE_Output);
            --  end if;
            
            Log.Msg (+"Check reg. app. for " & Mime_Application_Type & " MIME Type.");
            
            --  gio mime application/x-adagpr (check association between extension and application)
            --  Output is (in french):
            --
            --  Application par défaut pour « application/x-adagpr » : gps2020.desktop
            --  Applications inscrites :
            --  gps2020.desktop
            --  Applications recommandées :
            --  gps2020.desktop
            -- 
            --  So we should search for a line containing application/x-adagpr and then check gpsYYYY.desktop
            
            Sys.Shell_Execute ("gio mime " & Mime_Application_Type,
                               SE_Result,
                               SE_Output);
            if Log.Get_Debug then
               Log.Dbg (SE_Output);
            end if;
         
            Fls.Delete_File (Check_File_Name);
         else
            Log.Err ("Install_Registering - Can't create: " & Check_File_Name);
         end if;
      end if;
      
   end Install_Registering;
      
   ----------------------------------------------------------------------------   
   procedure Remove_Registering (Year_Install : VString) is
      Mime_Type_Application_Name : constant VString := Sys.Get_Home & 
                      "/.local/share/mime/application/" & Mime_Type & ".xml";

      Desktop_File_Name : constant VString := Sys.Get_Home & "/.local/share/applications/gps" & Year_Install & ".desktop";
      Desktop_File_Name_Old_1 : constant VString := Sys.Get_Home & "/.local/share/applications/gps.desktop";   
      Desktop_File_Name_Old_2 : constant VString := Sys.Get_Home & "/.local/share/applications/gnatstudio.desktop";  
                
   begin
   
      --  No need to deregister in server mode
      if GNAT_Target = "server" then
         Log.Msg (+"Server target: no need to deregister.");  
         return;
      end if;
   
      --  Desktop launcher can't stay to ease users because they reference the
      --  mime type with .gpr extension. Then you would end up with several 
      --  combinations of GNATStudio applications from different years, which
      --  should be avoided at all costs. We want to associate the .gpr 
      --  extension with one GNATStudio year edition at a time
      
      --  Clean old launchers without year in filename
      Fls.Delete_File (Desktop_File_Name_Old_1);
      Fls.Delete_File (Desktop_File_Name_Old_2); 
     
      if Fls.Exists (Desktop_File_Name) then
         Log.Msg (+"Deleting desktop launcher file.");
         Fls.Delete_File (Desktop_File_Name);
      else
         Log.Msg (+"Desktop launcher file already deleted.");
      end if;
         
      if Fls.Exists (Mime_Type_Package_Name) then
         Log.Msg (+"Deleting MIME type package file");
         Fls.Delete_File (Mime_Type_Package_Name);
      else
         Log.Msg (+"MIME type package file already deleted.");
      end if; 
      
      --  Automatically generated by update-mime-database
      if Fls.Exists (Mime_Type_Application_Name) then
         Log.Msg (+"Deleting MIME type application file");
         Fls.Delete_File (Mime_Type_Application_Name);
      else
         Log.Msg (+"MIME type application file already deleted.");
      end if; 
      
      Log.Msg (+"Updating MIME and Desktop databases.");
      
      --  update-mime-database /home/sr/.local/share/mime
      Sys.Shell_Execute (+"update-mime-database " & Sys.Get_Home & "/.local/share/mime");
         
      --  update-desktop-database /home/sr/.local/share/applications
      Sys.Shell_Execute (+"update-desktop-database " & Sys.Get_Home & "/.local/share/applications");

   end Remove_Registering;
    
   ---------------------------------------------------------------------------- 
   function Remove_Registering_All_Years return Boolean is
      Result : Boolean := False;
   begin
   
      --  No need to register in server mode
      if GNAT_Target = "server" then
         Log.Msg (+"Server target: no need to deregister.");  
         return True;
      end if;

      if Fls.Exists (GNAT_Dir & "/" & AIDE_Install_Ok_File) then
         for I in GNAT_Download'Range loop 
            Srv.Remove_Registering (To_VString(I));
            Fls.Delete_Lines (Sys.Get_Home & "/.bashrc", To_String 
                              (Sys.Get_Home & GNAT_Dir_Root &
                               To_VString(I) & "/bin:$PATH"));
         end loop;
         Result := True;
      end if;    
      return Result;
   end Remove_Registering_All_Years; 
   
   ----------------------------------------------------------------------------
   function Install_GNAT_Script (File_Name : VString) return Boolean is
      pragma Style_Checks (Off); -- Can't strip columns

      File_Handle : Tio.File;
      File_Content : VString := +"";
      LF : constant VString := To_VString (Character'Val (10));
      DQ : constant VString := To_VString (Character'Val (34));
      Result : Boolean := True;
   begin
   
      if Fls.Exists (File_Name) then
         Log.Msg ("Delete old GNAT installation script.");
         Fls.Delete_File (File_Name);
      end if;
      
      Log.Msg ("Generate GNAT installation script.");
      
      File_Content :=
      +"var install_dir = installer.value(" & DQ & "InstallPrefix" & DQ & ")" & LF &
      "var components  = installer.value(" & DQ & "Components" & DQ & ")" & LF &
      LF &
      "function Controller() {" & LF &
      "    installer.autoRejectMessageBoxes();" & LF &
      "    installer.installationFinished.connect(function() {" & LF &
      "        gui.clickButton(buttons.NextButton);" & LF &
      "    })" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.WelcomePageCallback = function() {" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.IntroductionPageCallback = function() {" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.TargetDirectoryPageCallback = function()" & LF &
      "{" & LF &
      "    gui.currentPageWidget().TargetDirectoryLineEdit.setText(install_dir);" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.ComponentSelectionPageCallback = function() {" & LF &
      "    if ((components != null) && (components != " & DQ & DQ & ")) {" & LF &
      "        var page = gui.currentPageWidget();" & LF &
      "        page.deselectAll();" & LF &
      "        complist = components.split(" & DQ & "," & DQ & ");" & LF &
      "        for (var i = 0; i < complist.length; i++) {" & LF &
      "            page.selectComponent(complist[i]);" & LF &
      "        }" & LF &
      "    }" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.LicenseAgreementPageCallback = function() {" & LF &
      "    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.StartMenuDirectoryPageCallback = function() {" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.ReadyForInstallationPageCallback = function()" & LF &
      "{" & LF &
      "    gui.clickButton(buttons.NextButton);" & LF &
      "}" & LF &
      LF &
      "Controller.prototype.FinishedPageCallback = function() {" & LF &
      "    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm" & LF &
      "    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {" & LF &
      "       checkBoxForm.launchQtCreatorCheckBox.checked = false;" & LF &
      "    }" & LF &
      "    gui.clickButton(buttons.FinishButton);" & LF &
      "}" & LF;
      
      Tio.Create (File_Handle, File_Name);
      Tio.Put_Line(File_Handle, File_Content);  
      Tio.Close (File_Handle);
      
      if Fls.Exists (File_Name) then
         Log.Msg ("GNAT installation script is ready.");
      else
         Log.Err ("Srv.Install_GNAT_Script - GNAT installation script not created.");
         Result := False;
      end if;
      return Result;
   end Install_GNAT_Script;  
   
   ----------------------------------------------------------------------------
   function Install_GNAT_Path (Dir_Install : VString) return Boolean is
      Bashrc_File : constant VString := Sys.Get_Home & "/.bashrc";
      Bashrc_Handle : Tio.File;
      --Bashrc_Buffer : VString := +"";
      --Bashrc_Path_Unset : Boolean := True;
      Env_Path_Set : Boolean := False;
      --LF : constant VString := To_VString (Character'Val (10));
   begin

      if not Fls.Exists (Dir_Install) then
         if Fls.Create_Directory_Tree (Dir_Install) then
            Log.Msg ("GNAT directory created : " & Dir_Install);
         else
            Log.Err ("Srv.Install_GNAT_Path - Can't create directory " & Dir_Install);
         end if;
      end if;

      if Fls.Exists (Bashrc_File) then

         Tio.Open_Read (Bashrc_Handle, Bashrc_File);
         if Tio.Is_Open (Bashrc_Handle) then
            --  --  Search permanent PATH
            --  while not (Tio.End_Of_File (Bashrc_Handle)) loop
            --     Tio.Get_Line (Bashrc_Handle, Bashrc_Buffer);
            --     if Index (Bashrc_Buffer, Dir_Install & "/bin:$PATH") > 0 then
            --        Bashrc_Path_Unset := False;
            --        Log.Msg ("GNAT path already exists in " & Bashrc_File);
            --     end if;
            --  end loop;

            Tio.Close (Bashrc_Handle);
            
            --  Delete all previous PATH
            for I in 2019 .. 2021 loop
               Fls.Delete_Lines (Bashrc_File, To_String (Sys.Get_Home & GNAT_Dir_Root & To_VString (I) & "/bin:$PATH"));
            end loop;

            --  Set new permanent PATH
            --if Bashrc_Path_Unset then
               Tio.Append (Bashrc_Handle, Bashrc_File);
               if Tio.Is_Open (Bashrc_Handle) then
                  -- A first LF is mandatory to circumvent the vicious case of
                  -- a last file line which is a commented one and not ending
                  -- by a LF (new line) character thus the string is inserted
                  -- at the end of the commented line instead but wrote on a
                  -- new line !
                  Tio.Put_Line (Bashrc_Handle, LF & "export PATH=" 
                                                  & Dir_Install 
                                                  & "/bin:$PATH");
                  Tio.Close (Bashrc_Handle);
                  Log.Msg ("GNAT path " & Dir_Install & " set in " & Bashrc_File);
               else
                  Log.Err ("Srv.Install_GNAT_Path - Can't append " & Bashrc_File);
               end if;
            --end if;

            --  Exit for current session when no PATH still set
            if Index (Sys.Get_Env ("PATH"), Dir_Install) = 0 then
               Srv.Help_Block_2;
               ---Log.Msg ("--------------------------------------------------");
               ---Log.Msg ("Launch a new terminal or execute the line below.");
               ---Log.Msg ("export PATH=" & Dir_Install & "/bin:$PATH");
               if AIDE_Action = Install_Action then
                  Log.Msg ("Run again AIDE to resume and finish the installation.");
               end if;   
               ---Log.Msg ("/!\ Not follow this advice could rising problems.");
               Log.Msg ("--------------------------------------------------");
            else
               Log.Msg ("GNAT path " & Dir_Install & " already in PATH");
               Log.Msg ("GNAT path OK, no need to start a new console");
               Env_Path_Set := True;
            end if;
         else
            Log.Err ("Srv.Install_GNAT_Path - Can't open " & Bashrc_File);
         end if;
      else
         Log.Err ("Srv.Install_GNAT_Path - Can't find " & Bashrc_File);
      end if;
      return Env_Path_Set;
   end Install_GNAT_Path;
  
   ----------------------------------------------------------------------------
   function Install_GNAT_Debug_RTS (Year_Install : VString) return Boolean is
      Exec_Error : Integer;
      GNAT_RTS_Version, GNAT_RTS, GNAT_RTS_Debug : VString := +"";
      DQ : constant VString := To_VString (Character'Val (34));
      Result : Boolean := False;
   begin
      Log.Msg ("Building GNAT debug runtime.");

      if Year_Install = "2019" then
         GNAT_RTS_Version := +"8.3.1";
         return True;
         -- Non understandable regression building GNAT debug RTS for CE 2019. By
         -- lack of time and interest, fix this with a wild return to continue
         -- the installation.
         -- /home/sr/opt/gnat-2019/lib/gcc/x86_64-pc-linux-gnu/8.3.1/adainclude/init.c
         -- :583:18: error: missing binary operator before token "("
         -- # if 16 * 1024 < MINSIGSTKSZ
         --                  ^~~~~~~~~~~
      elsif Year_Install = "2020" then
         GNAT_RTS_Version := +"9.3.1";
      elsif Year_Install = "2021" then
         GNAT_RTS_Version := +"10.3.1";
      end if;
      
      GNAT_RTS := GNAT_Dir & "/lib/gcc/x86_64-pc-linux-gnu/" & 
        GNAT_RTS_Version & "/rts-native/adalib";
      GNAT_RTS_Debug := GNAT_Dir & "/lib/gcc/x86_64-pc-linux-gnu/" & 
        GNAT_RTS_Version & "/rts-native-debug/adalib";
    
      -- Patch Makefile.adalib need for CE 2021
      --  if Year_Install = "2021" then
      --     if Fls.Exists (GNAT_RTS & "/Makefile.adalib") then
      --        if Fls.Search_Lines (GNAT_RTS & "/Makefile.adalib", "tb-gcc.c") then
      --           Log.Msg ("Need to patch: " & GNAT_RTS & "/Makefile.adalib");
      --  
      --           -- tb-gcc.c no longer exists in CE 2021 but reusing CE 2020 makefile.adalib
      --           Sys.Shell_Execute ("sed 's/tb-gcc.c//g' " & GNAT_RTS & "/Makefile.adalib" & " > " & GNAT_RTS & "/Makefile.tmp", Exec_Error);
      --  
      --           if (Exec_Error = 0) then
      --              Sys.Shell_Execute ("mv -f " & GNAT_RTS & "/Makefile.tmp " & GNAT_RTS & "/Makefile.adalib", Exec_Error);
      --              if (Exec_Error = 0) then
      --                 Log.Msg ("Successfully patching: " & GNAT_RTS & "/Makefile.adalib");
      --              else
      --                 Log.Err ("mv -f " & GNAT_RTS & "/Makefile.tmp " & GNAT_RTS & "/Makefile.adalib");
      --                 Log.Err ("Srv.Install_GNAT_Debug_RTS - Error writing Makefile.adalib, error: " & To_VString(Exec_Error));
      --              end if;
      --           else
      --              Log.Err ("mv -f " & GNAT_RTS & "/Makefile.tmp " & GNAT_RTS & "/Makefile.adalib");
      --              Log.Err ("Srv.Install_GNAT_Debug_RTS - Error patching Makefile.adalib, error: " & To_VString(Exec_Error));
      --           end if;
      --        end if;
      --     end if;
      --  end if;
      
      if Fls.Create_Directory_Tree (GNAT_RTS_Debug) then
         Fls.Copy_File (GNAT_RTS & "/Makefile.adalib", 
                        GNAT_RTS_Debug & "/Makefile.adalib");
         
         -- adainclude link to original RTS
         Sys.Shell_Execute ("ln -s " & 
                            GNAT_Dir & 
                            "/lib/gcc/x86_64-pc-linux-gnu/" & 
                            GNAT_RTS_Version & 
                            "/rts-native/adainclude " &
                            GNAT_Dir & 
                            "/lib/gcc/x86_64-pc-linux-gnu/" & 
                            GNAT_RTS_Version & 
                            "/rts-native-debug/adainclude");
                                   
         if Fls.Set_Directory (GNAT_RTS_Debug) then
         
            Sys.Shell_Execute ("make -f Makefile.adalib ROOT=" & 
                               GNAT_Dir & " CFLAGS=" & DQ & 
                               "-g -O0" & DQ, Exec_Error);
            if (Exec_Error = 0) then
               Log.Msg ("GNAT debug run-time build sucessfully.");
               Result := True;
            else
               Log.Err ("Srv.Install_GNAT_Debug_RTS - Can't make GNAT debug RTS.");
            end if;
         else
            Log.Err ("Srv.Install_GNAT_Debug_RTS - Can't change to GNAT debug RTS build directory.");
         end if;
      else
         Log.Err ("Srv.Install_GNAT_Debug_RTS - Can't create GNAT debug RTS directory.");
      end if;
      return Result;
   end Install_GNAT_Debug_RTS;
   
   ---------------------------------------------------------------------------- 
   function Install_GNAT_Pack (File_Pack : VString) return Boolean is
      Exec_Error : Integer;
      Result : Boolean := False;
      
   begin
   
      --  Decompress package to tar archive file
      Log.Msg("Decompress: " & File_Pack & ".xz");
      Sys.Shell_Execute ("xz -dv --threads=4 " & File_Pack & ".xz", Exec_Error);
      if (Exec_Error = 0) then
         --  Move to directory to unarchive tar file at the proper place 
         if Fls.Set_Directory (GNAT_Dir) then
            --  Detar archive without single root directory
            Log.Msg("GNAT installation from archive: "& File_Pack);
            Sys.Shell_Execute ("tar xf " & File_Pack & " --strip-components=1", Exec_Error); 
         if (Exec_Error = 0) then
               Fls.Delete_File(File_Pack);
               Result := True;
            end if;
         end if;
      end if;
      
      return Result;
                  
   end Install_GNAT_Pack;
   
   ----------------------------------------------------------------------------   
   function Install_GNAT (Year_Install : VString) return Boolean is
   
      GNAT_Dir_Pack : constant VString := Sys.Get_Home & GNAT_Dir_Root & Year_Install & "-packages";
   
      --  Script_Name : constant VString := +"install_script.qs";
   
      --  Build_String : VString := " --script ./" & Script_Name &
      --                            " --platform minimal --verbose" &
      --                            " InstallPrefix=" & GNAT_Dir;
   
      GNAT_Handle : Tio.File;
      GNAT_Size : Integer := 0;
      --  Exec_Error : Integer;
      --  Gnat_Dir_Clean : Boolean := True;
      
      Gnat_Installed : Boolean := False;
      Result : Boolean := False;
      
      Year_Install_Index : constant Natural := To_Integer(Year_Install);

      GNAT_Pack_Org : constant VString := GNAT_Dir_Pack & "/" &
                                          GNAT_Download(Year_Install_Index).Name & "-" &
                                          GNAT_Target & ".tar.xz";
      GNAT_Pack_Dest : constant VString := GNAT_Dir & "/" & 
                                          GNAT_Download(Year_Install_Index).Name & "-" & 
                                          GNAT_Target & ".tar"; 

      --  GNAT_File : constant VString := GNAT_Dir_Dl & "/gnat-" & Year_Install & "-install";
      
begin 
      --  If GNAT not already successfully installed
      if not Fls.Exists (GNAT_Dir & "/" & AIDE_Install_Ok_File) then
         --  Delete previous partial install
         if Fls.Exists (GNAT_Dir) then
            Sys.Shell_Execute ("rm -fr " & GNAT_Dir);
            Log.Msg("Delete previous GNAT unfinished install");
         end if;
         
         if not Fls.Exists (GNAT_Dir) then
         
            --  Attempt to get AIDE local package
            if Fls.Exists (GNAT_Pack_Org) then
               Log.Msg("Try to install GNAT from AIDE local package repository.");
               
               --  Create install directory
               if Fls.Create_Directory_Tree (GNAT_Dir) then
                  --  Copy package to install directory
                  Fls.Copy_File (GNAT_Pack_Org, GNAT_Pack_Dest & ".xz");
                  
                     Gnat_Installed := Install_GNAT_Pack (GNAT_Pack_Dest);
                     
               end if;
            end if;
            
            --  Attempt to get AIDE distant package
            if not Gnat_Installed then
               Log.Msg("Try to install GNAT from AIDE distant package repository.");
               
               if GNAT_Target = "server" then      
                  GNAT_Size := GNAT_Download(Year_Install_Index).Server_Size;
               elsif GNAT_Target = "station" then
                  GNAT_Size := GNAT_Download(Year_Install_Index).Station_Size;
               end if;
               --  Create install directory
               if Fls.Create_Directory_Tree (GNAT_Dir) then
               
                  if Fls.Download_File (AIDE_Root_Url_Download_Packs & 
                                        GNAT_Download(Year_Install_Index).Name & 
                                        "-" & GNAT_Target & ".tar.xz", 
                                        GNAT_Pack_Dest & ".xz", 
                                        +"", 
                                        GNAT_Size) then
                                        
                     Gnat_Installed := Install_GNAT_Pack (GNAT_Pack_Dest);
        
                  end if;
               end if;
            end if;
            
            --  Attempt to get AdaCore distant package
            --  if not Gnat_Installed then
            --     Log.Msg("Try to install GNAT from AdaCode repository.");
            --  
            --     if Fls.Download_File (GNAT_Download(Year_Install_Index).Install_Url,
            --                           GNAT_File, +"GNAT",
            --                           GNAT_Download(Year_Install_Index).Install_Size) then
            --  
            --        Log.Msg ("GNAT installation from installer: " & GNAT_File);
            --  
            --        --  Generate install_script.qs
            --        if Install_GNAT_Script (Gnat_Dir_Dl & "/" & Script_Name) then
            --  
            --           Sys.Shell_Execute (+"chmod +x " & GNAT_File, Exec_Error);
            --  
            --           --  GNAT, GPS and all related GNU tools
            --  
            --           --  Components is an optional argument which specifies a list
            --           --  of components to install. The list is comma-separated
            --           --  without spaces. Without this argument, the entire package
            --           --  is installed. Components available are : com.adacore.gnat
            --           --  com.adacore.libadalang com.adacore.spark2014_discovery and
            --           --  com.adacore.gnatstudio.
            --  
            --           --  If server, limit to GNAT core (compiler only)
            --           if GNAT_Target = "server" then
            --              Build_String := GNAT_File & Build_String &
            --                " Components=com.adacore.gnat";
            --           elsif GNAT_Target = "station" then
            --              Build_String := GNAT_File & Build_String;
            --           end if;
            --  
            --           if Fls.Set_Directory (GNAT_Dir_Dl) then
            --              Log.Msg ("Change to GNAT installation directory.");
            --  
            --              --  Wipe partial previous install
            --              if Fls.Exists (GNAT_Dir) then
            --                 if Fls.Delete_Directory_Tree (GNAT_Dir) then
            --                    Log.Msg ("Previous partial GNAT install detected and deleted.");
            --                 else
            --                    Gnat_Dir_Clean := False;
            --                    Log.Err ("Srv.Install_GNAT - Can't delete previous partial GNAT install.");
            --                 end if;
            --              end if;
            --  
            --              if Gnat_Dir_Clean then
            --                 Sys.Shell_Execute (Build_String, Exec_Error);
            --                 if Fls.Exists (Gnat_Dir_Dl & "/" & Script_Name) then
            --                    Log.Msg (+"Delete GNAT installation script.");
            --                    Fls.Delete_File (Gnat_Dir_Dl & "/" & Script_Name);
            --                 end if;
            --                 if (Exec_Error = 0) then
            --                    Gnat_Installed := True;
            --                 else
            --                    Log.Err ("Srv.Install_GNAT - GNAT installer failed.");
            --                 end if;
            --              end if;
            --           else
            --              Log.Err ("Srv.Install_GNAT - Can't change to installation directory.");
            --           end if;
            --        else
            --           Log.Err ("Srv.Install_GNAT - GNAT installation script not generated.");
            --        end if;
            --     else
            --        Log.Err ("Srv.Install_GNAT - GNAT install file not found");
            --     end if;
            --  end if;
            
            -- GNAT finalization
            if Gnat_Installed then
               Log.Msg ("GNAT install done.");
               if (GNAT_Target = "server") then
                  Result := True;
               else
                  if Install_GNAT_Debug_RTS (Year_Install) then
                     Log.Msg ("GNAT debug ready RTS done.");
            
                     Tio.Create (GNAT_Handle, GNAT_Dir & "/" & AIDE_Install_Ok_File);
                     Tio.Close (GNAT_Handle);
                     if Fls.Exists (GNAT_Dir & "/" & AIDE_Install_Ok_File) then
                        Log.Msg ("GNAT install complete.");
                        Result := True;
                     else
                        Log.Err ("GNAT install not successfull.");
                     end if;
                  else
                     Log.Err ("Srv.Install_GNAT - Can't install GNAT debug ready RTS.");
                  end if;
               end if;
            end if;
            
         else
            Log.Err ("Srv.Install_GNAT - Can't delete previous unfinished install before processing: " & GNAT_Dir);
         end if;
      
      else
         Log.Msg ("Srv.Install_GNAT - GNAT install already exists in " & GNAT_Dir);
      end if;  

      --  Return True here means we must proceed to next installation steps
      return Result; 
   end Install_GNAT;
   
   ----------------------------------------------------------------------------  
   procedure Create_GNAT_Pack_Files (File_Install : VString;
                                     Year_Install : VString;
                                     Dir_Install : VString;
                                     Type_Install : VString;
                                     Build_Install : VString) is
      GNAT_Fix_Path : VString := +"";
      Result : Boolean := False;    
      Exec_Error : Integer;
   
   begin   

      --  Delete previous install
      Sys.Shell_Execute ("rm -fr " & Dir_Install & "/" & Type_Install);
      
      if not (Fls.Exists(Dir_Install & "/" & Type_Install)) then
                 
         -- Install
         Sys.Shell_Execute (File_Install & Build_Install, Exec_Error);
         if (Exec_Error = 0) then
            
            --  Special case for missing script Makefile.adalib
            --  in GNAT 2021 CE, so recycle the 2020 version.
            if Year_Install = "2021" then
               GNAT_Fix_Path := Sys.Get_Home & GNAT_Dir_Root &
                              "2021-packages/" & Type_Install & "/lib/gcc/x86_64-pc-linux-gnu/" &
                              "10.3.1/rts-native/adalib";
            
               Fls.Copy_File (Sys.Get_Home & GNAT_Dir_Root &
                              "2020-packages/" & Type_Install & "/lib/gcc/x86_64-pc-linux-gnu/" &
                              "9.3.1/rts-native/adalib/Makefile.adalib", GNAT_Fix_Path & "/Makefile.adalib");
                      
               -- Patch Makefile.adalib need for CE 2021
               if Fls.Exists (GNAT_Fix_Path & "/Makefile.adalib") then
               
                  -- tb-gcc.c no longer exists in CE 2021 but reusing CE 2020 makefile.adalib
                  Sys.Shell_Execute ("sed 's/tb-gcc.c//g' " & GNAT_Fix_Path & "/Makefile.adalib" & " > " & GNAT_Fix_Path & "/Makefile.tmp", Exec_Error);
                  
                  if (Exec_Error = 0) then
                     Sys.Shell_Execute ("mv -f " & GNAT_Fix_Path & "/Makefile.tmp " & GNAT_Fix_Path & "/Makefile.adalib", Exec_Error);
                     if (Exec_Error = 0) then
                        Log.Msg ("Successfully patching: " & GNAT_Fix_Path & "/Makefile.adalib");
                     end if;
                  end if;
               end if;
            end if;
            
            Log.Msg ("GNAT " & Type_Install & " install done. Creating package.");
            
            --  Delete files from previous install to avoid errors
            Fls.Delete_File(File_Install & "-" & Type_Install & ".tar");
            Fls.Delete_File(File_Install & "-" & Type_Install & ".tar.xz");
            
            --  tar -C /home/sr/opt/gnat-YYYY-packages -cf gnat-YYYY-YYYYMMDD-linux-64-station|server.tar station|server
            Sys.Shell_Execute ("tar -C " & Dir_Install & " -cf " & File_Install & "-" & Type_Install & ".tar " & Type_Install, Exec_Error);
            
            if (Exec_Error = 0) then
               Sys.Shell_Execute ("xz -9v --threads=4 " & File_Install & "-" & Type_Install & ".tar", Exec_Error);
               if (Exec_Error = 0) then
                  Result := True;
               else
                  Log.Err ("Srv.Create_GNAT_Pack_Files - GNAT compression failed for " & Type_Install & " , error: " & To_VString(Exec_Error));
               end if;
            else
               Log.Err ("Srv.Create_GNAT_Pack_Files - GNAT archive failed for " & Type_Install & " , error: " & To_VString(Exec_Error));
            end if;
         else
            Log.Err ("Srv.Create_GNAT_Pack_Files - GNAT installer failed for " & Type_Install & " , error: " & To_VString(Exec_Error));
         end if;
         
         if Result then
            Log.Msg ("GNAT package created: " & File_Install & "-" & Dir_Install & ".tar.xz");
         else
            Log.Err ("Srv.Create_GNAT_Pack_Files - GNAT package failed: " & File_Install & "-" & Dir_Install & ".tar.xz");
         end if;
         
      else
         Log.Err ("Srv.Create_GNAT_Pack_Files - " & File_Install & " directory not deleted");
      end if;
      
   end Create_GNAT_Pack_Files;
   
   ----------------------------------------------------------------------------   
   procedure Create_GNAT_Pack (Year_Install : VString) is
      GNAT_Dir_Pack : constant VString := Sys.Get_Home & GNAT_Dir_Root & Year_Install & "-packages";
      
      -- GNAT_Dir_Pack_Station : constant VString := GNAT_Dir_Pack & "/station";       
      -- GNAT_Dir_Pack_Server : constant VString := GNAT_Dir_Pack & "/server"; 
                                             
     Script_Name : constant VString := +"install_script.qs";
     Build_String : constant VString := " --script ./" & Script_Name &
                                     " --platform minimal --verbose" &
                                     " InstallPrefix=" & GNAT_Dir_Pack;
                                      
      Year_Install_Index : constant Natural := To_Integer(Year_Install);
      GNAT_File : constant VString := GNAT_Dir_Pack & "/" & GNAT_Download(Year_Install_Index).Name;

      Download_Needed : Boolean := True;
      Result : Boolean := True;    
      Exec_Error : Integer;
   begin 

      Log.Msg ("Processing GNAT-" & Year_Install & " for packing.");    
         
      if Fls.Exists (GNAT_File) then
         if Fls.File_Size (GNAT_File) = GNAT_Download (Year_Install_Index).Install_Size then
            Download_Needed := False;
            Log.Msg (GNAT_File & " already downloaded");
         end if;
      end if;
      
      if Download_Needed then

         Log.Msg ("Downloading GNAT-" & Year_Install & " for packing.");    
      
         -- Set up directory
         if Result then
            if Fls.Create_Directory_Tree (GNAT_Dir_Pack) then
               Log.Msg ("Create genpack directory: " & GNAT_Dir_Pack);
            else 
               Log.Err ("Srv.Create_GNAT_Pack - Fail to create genpack directory: " & GNAT_Dir_Pack);
               Result := False;
            end if;
         end if;
         
         -- Download file
         if Result then
            if Fls.Download_File (GNAT_Download(Year_Install_Index).Install_Url, 
                                  GNAT_File,
                                  "GNAT-" & Year_Install, 
                                  GNAT_Download(Year_Install_Index).Install_Size) then
               Log.Msg (GNAT_File & " downloaded successfully");     
            else
               Result := False;
            end if;
         end if;
       
      end if;

      --  Installation
      if Result then
         --  Set install file executable
         Sys.Shell_Execute (+"chmod +x " & GNAT_File, Exec_Error);
         if (Exec_Error = 0) then
            -- Generate install_script.qs
            if Install_GNAT_Script (GNAT_Dir_Pack & "/" & Script_Name) then 
                  
               if Fls.Set_Directory (GNAT_Dir_Pack) then
                  Log.Msg ("Change to GNAT installation directory.");
                  
                  --  Maximum multi-thread compression 
                  --  
                  --  with xz -9e    +--- AIDE ---+ 
                  --        Adacore  Station Server
                  --  2019  493M     430M    172M
                  --  2020  631M     534M    179M 
                  --  2021  720M     603M    192M
                  --       1844M    1567M    543M
                  --  Total execution time: 1h12m03s
                  --
                  --  with xz -9     +--- AIDE ---+ < Our choice : best ratio time/compression (18 mn less for 2-7M more)
                  --        Adacore  Station Server               
                  --  2019  493M     432M    173M
                  --  2020  631M     536M    180M    
                  --  2021  720M     606M    192M
                  --       1844M    1574M    545M
                  --  Total execution time: 0h54m28s             
                  
                  Create_GNAT_Pack_Files (GNAT_File, Year_Install, GNAT_Dir_Pack, +"station", Build_String & "/station");
                  Create_GNAT_Pack_Files (GNAT_File, Year_Install, GNAT_Dir_Pack, +"server", Build_String & "/server Components=com.adacore.gnat");
                     
                  end if;
            end if;                    
         end if;
      end if;
      
   end Create_GNAT_Pack;

   ----------------------------------------------------------------------------
   procedure Remove_GNAT is
   begin
      if Fls.Exists (GNAT_Dir) then
         Log.Msg (+"Deleting: " & GNAT_Dir);
         --  Ultimate security to avoid rm -rf /home/user. GNAT_Dir must
         --  contains /home/user and GNAT_Dir has (at least) one child 
         --  directory of a single letter : >= 2 test i.e. "/d"
         if Index (GNAT_Dir, Sys.Get_Home) > 0 and
           Length (GNAT_Dir) >= Length (Sys.Get_Home) + 2 then
           --  Fls.Delete_Directory_Tree is raise an exception if directory 
           --  tree contains broken symbolic files, so using rm...
           Sys.Shell_Execute ("rm --force --recursive " & GNAT_Dir);
         else
            Log.Err ("Srv.Remove_GNAT - Check GNAT_Dir: " & GNAT_Dir);
         end if;
         if Fls.Exists (GNAT_Dir) then
            Log.Err ("Srv.Remove_GNAT - Can't delete : " & GNAT_Dir);
         end if;
      else
         Log.Msg (GNAT_Dir & " already deleted.");
      end if;
      if Fls.Exists (GNAT_Dir_Dl) then
         Log.Msg ("Deleting " & GNAT_Dir_Dl);
         if not Fls.Delete_Directory_Tree (GNAT_Dir_Dl) then
            Log.Err ("Srv.Remove_GNAT - Can't delete : " & GNAT_Dir_Dl);
         end if;
      else
         Log.Msg (GNAT_Dir_Dl & " already deleted.");
      end if;
   end Remove_GNAT;

   ----------------------------------------------------------------------------
   procedure Install_Libraries (Year_Install : VString) is
      pragma Style_Checks (Off); -- Can't strip columns
      
      -- GaillyAdler_Zlib_Url, GaillyAdler_Zlib_File, StCarrez_Adautil_Url, 
      GNAT_AWS_Url, GNAT_AWS_File, GNAT_ASIS_Url, GNAT_ASIS_File, 
      Adalog_Adacontrol_Url, Adalog_Adacontrol_File, GdMontmollin_HAC_Url : VString;
      Lib_Size : Integer := 0;
      
      STD_OUT_REDIRECT : constant VString := +" 1>/dev/null ";
   begin

      --  General installation behavior is to create a non versioned build 
      --  subdirectory and strip versioned directory inside the tar file

      --  Already tested at this stage
      --  if not (Index (Sys.Get_Env ("PATH"), GNAT_Dir) = 0) -- GNAT path ok
      --  and Fls.Exists (GNAT_Dir & "/bin/gnat") then    -- GNAT install ok 
      
      --  Docs & examples --------------------------------------------------

      --  Ada Web Server build - https://github.com/AdaCore/aws
      --  Already installed by GNAT in ./lib/aws.*, but without
      --  docs nor examples

      if not Fls.Exists (GNAT_Dir_Dl & "/aws") then
         
         if (Year_Install = "2019") then
            GNAT_AWS_Url := +"https://community.download.adacore.com/v1/" & 
                     "110b3f623b4487874a714d3cf29aa945680766a6?filename=" & 
                                      "aws-2019-20190512-18AB9-src.tar.gz";
            Lib_Size := 4241817;
         elsif (Year_Install = "2020") then
            GNAT_AWS_Url:= +"https://community.download.adacore.com/v1/" & 
                     "7e3da84e9f4ed64fa6c322a0824882e99cd7e723?filename=" &
                     "aws-2020-20200814-19BA4-src.tar.gz";
            Lib_Size := 4239133;
         elsif (Year_Install = "2021") then
            GNAT_AWS_Url:= +"https://community.download.adacore.com/v1/" & 
                     "5b0fa09df8ac0c717abdf4ede9e08efe5fd98984?filename=" &
                     "aws-2021-20210518-19F65-src.tar.gz";
            Lib_Size := 4351625;
         end if;
         GNAT_AWS_File := GNAT_Dir_Dl & "/aws-" & GNAT_Year & "-install.tar.gz";

         --  Download message is outputted in Fls.Download_File
         if Fls.Download_File (GNAT_AWS_Url, GNAT_AWS_File, +"AdaWebServer", Lib_Size) then
            Log.Msg ("Ada Web Server docs & examples installation.");
            
            if Fls.Create_Directory_Tree (GNAT_Dir_Dl & "/aws") then
               Sys.Shell_Execute ("tar xzf " & GNAT_AWS_File & " --strip-components=1 -C " & GNAT_Dir_Dl & "/aws");
               --  Use GNAT embedded release
               --  Set_Directory (GNAT_Dir_Dl & "/aws"); 
               --  Shell_Execute ("make SOCKET=openssl setup build install");
               if Fls.Create_Directory_Tree (GNAT_Dir & "/share/doc/aws") then
                  Fls.Copy_File (GNAT_Dir_Dl & "/aws/docs/aws.pdf", GNAT_Dir & "/share/doc/aws/aws.pdf");
                  Fls.Copy_File (GNAT_Dir_Dl & "/aws/docs/templates_parser.pdf", GNAT_Dir & "/share/doc/aws/templates_parser.pdf");
                  if Fls.Create_Directory_Tree (GNAT_Dir & "/share/examples/aws-demos") then    
                     Sys.Shell_Execute ("cp -rf " & GNAT_Dir_Dl & "/aws/demos/* " & GNAT_Dir & "/share/examples/aws-demos");
                  end if;
               end if;
            end if;
         end if;
      else  
         Log.Msg ("Ada Web Server docs & examples already installed.");
      end if;

      --  Libraries and packages ----------------------------------------------
      
      --  --  Ada-Util
      --  
      --  if not Fls.Exists (GNAT_Dir & "/lib/utilada_core.static/libutilada_core.a") then
      --     StCarrez_Adautil_Url := +"https://github.com/stcarrez/ada-util";
      --     if Fls.Set_Directory (GNAT_Dir_Dl) then
      --  
      --        Log.Msg (+"Download Utilada.");
      --        Sys.Shell_Execute ("git clone " & StCarrez_Adautil_Url);
      --        Log.Msg (+"Utilada installation.");
      --  
      --        Fls.Rename (GNAT_Dir_Dl & "/ada-util", GNAT_Dir_Dl & "/utilada");
      --        if Fls.Set_Directory (GNAT_Dir_Dl & "/utilada") then
      --           --  ./configure --enable-aunit --disable-ahven --prefix=/home/sr/opt/gnat-2020
      --           --  make install prefix=/home/sr/opt/gnat-2020
      --           Sys.Shell_Execute (+"./configure " &
      --                              "--enable-aunit --disable-ahven " & -- mutually exclusive
      --                              "--prefix=" & GNAT_Dir);
      --           Sys.Shell_Execute ("make");
      --           --  Shell_Execute ("make test");
      --           Sys.Shell_Execute ("make install");
      --           if Fls.Create_Directory_Tree (GNAT_Dir & "/share/doc/utilada") then
      --              Fls.Copy_File (GNAT_Dir_Dl & "/utilada/docs/utilada-book.pdf", GNAT_Dir & "/share/doc/utilada/utilada.pdf");
      --           end if;
      --        end if;
      --     end if;
      --  else
      --     Log.Msg (+"Utilada already installed.");
      --  end if;
      --  
      --  --  Zlib build - https://github.com/madler/zlib -------------------------
      --  --  Embedding use in ./lib/aws.*, but no external libz.a usuable
      --  
      --  if not Fls.Exists (GNAT_Dir & "/lib/libz.a") then
      --     GaillyAdler_Zlib_Url := +"https://zlib.net/zlib-1.2.11.tar.gz";
      --     -- GCC linker -L parameter don't accept dots in path
      --     GaillyAdler_Zlib_File := GNAT_Dir_Dl & "/zlib-1-2-11.tar.gz";
      --  
      --     --  Download message is outputted in Fls.Download_File
      --     if Fls.Download_File (GaillyAdler_Zlib_Url, GaillyAdler_Zlib_File, +"Zlib", 607698) then
      --        Log.Msg (+"Zlib installation.");
      --  
      --        if Fls.Create_Directory_Tree (GNAT_Dir_Dl & "/zlib") then
      --           Sys.Shell_Execute ("tar xzf " & GaillyAdler_Zlib_File & " --strip-components=1 -C " & GNAT_Dir_Dl & "/zlib");
      --           if Fls.Set_Directory (GNAT_Dir_Dl & "/zlib") then
      --              Sys.Shell_Execute ("./configure --static"); -- prefix= not working
      --              Sys.Shell_Execute ("make");
      --              Sys.Shell_Execute ("rm -f *.o *.lo");
      --              Fls.Copy_File (GNAT_Dir_Dl & "/zlib/libz.a", GNAT_Dir & "/lib/libz.a");
      --              --  zlib.gpr use system wide zlib by default, see AIDE manual how to link zlib statically
      --              if Fls.Set_Directory (To_String (GNAT_Dir_Dl & "/zlib/contrib/ada")) then
      --                 Sys.Shell_Execute ("gprbuild -d -P./zlib.gpr");
      --              end if;
      --           end if;
      --        end if;
      --     end if;
      --  else
      --     Log.Msg ("Zlib already installed.");
      --  end if;

      --  Tools ---------------------------------------------------------------

      --  ASIS build - https://github.com/simonjwright/ASIS
      --  Mandatory for Adacontrol - This is the 2019 AdaCore version, not
      --  the Github one. Important: ASIS 2019 is the last CE Edition :(

      if (To_Integer(Year_Install) <= 2019) then
         if not Fls.Exists (GNAT_Dir & "/lib/asis/asislib/libasis.a") then
            GNAT_ASIS_Url := +"https://community.download.adacore.com/v1/52c69e7295dc301ce670334f8150193ecbec580d?filename=asis-2019-20190517-18AB5-src.tar.gz";
            GNAT_ASIS_File := GNAT_Dir_Dl & "/asis-2019.tar.gz";

            --  Download message is outputted in Fls.Download_File
            if Fls.Download_File (GNAT_ASIS_Url, GNAT_Asis_File, +"ASIS") then
               Log.Msg (+"ASIS 2019 installation.");
               
               if Fls.Create_Directory_Tree (GNAT_Dir_Dl & "/asis") then
                  Sys.Shell_Execute ("tar xzf " & GNAT_ASIS_File & " --strip-components=1 -C " & GNAT_Dir_Dl & "/asis");   
                  if Fls.Set_Directory (GNAT_Dir_Dl & "/asis") then
                     Sys.Shell_Execute ("make all install prefix=" & GNAT_Dir);
                  end if;
               end if;
            end if;
         else  
            Log.Msg ("ASIS already installed.");
         end if;
      end if;
      
      --  Adacontrol - https://github.com/Adalog-fr/Adacontrol
      --  Can only be build with the GNAT CE 2019 as ASIS 2019 is the last edition

      if (To_Integer(Year_Install) <= 2019) then
         if not Fls.Exists (GNAT_Dir & "/bin/adactl") then
            Adalog_Adacontrol_Url := +"https://sourceforge.net/projects/adacontrol/files/adactl-src.tgz";
            Adalog_Adacontrol_File := GNAT_Dir_Dl & "/adactl-src-latest.tgz";
            
            --  Download message is outputted in Fls.Download_File
            if Fls.Download_File (Adalog_Adacontrol_Url, Adalog_Adacontrol_File, +"Adacontrol") then 
               Log.Msg ("Adacontrol installation.");
            
               if Fls.Create_Directory_Tree (GNAT_Dir_Dl & "/adacontrol") then
                  Sys.Shell_Execute ("tar xzf " &  Adalog_Adacontrol_File & " --strip-components=1 -C " & GNAT_Dir_Dl & "/adacontrol"); 
                  if Fls.Set_Directory (GNAT_Dir_Dl & "/adacontrol") then
                     Sys.Shell_Execute ("gprbuild -d -P./build.gpr -XGPR_BUILD=static -XXMLADA_BUILD=static -XGNATCOLL_CORE_BUILD=static -XGNATCOLL_BUILD=static -XASIS_BUILD=static");
                     Sys.Shell_Execute ("make install");
                     Sys.Shell_Execute ("make clean" & STD_OUT_REDIRECT);
                     if Fls.Create_Directory_Tree (GNAT_Dir & "/share/doc/adacontrol") then
                        Fls.Copy_File (GNAT_Dir_Dl & "/adacontrol/doc/adacontrol_pm.pdf",GNAT_Dir & "/share/doc/adacontrol/adacontrol_pm.pdf");
                        Fls.Copy_File (GNAT_Dir_Dl & "/adacontrol/doc/adacontrol_ug.pdf",GNAT_Dir & "/share/doc/adacontrol/adacontrol_ug.pdf");
                     end if;
                  end if;
               end if;
            end if;
         else  
            Log.Msg (+"Adacontrol already installed.");
         end if;
      end if;

      -- HAC - https://github.com/zertovitch/hac

      if not Fls.Exists (GNAT_Dir & "/bin/hac") then
         GdMontmollin_HAC_Url := +"https://github.com/zertovitch/hac";
         if Fls.Set_Directory (GNAT_Dir_Dl) then
         
            Log.Msg (+"Download HAC.");
            Sys.Shell_Execute ("git clone " & GdMontmollin_HAC_Url);
            Log.Msg (+"HAC installation.");
            
            if Fls.Set_Directory (GNAT_Dir_Dl & "/hac") then
               Sys.Shell_Execute ("gprbuild -d -P./hac.gpr -XHAC_OS=Linux");
               Fls.Copy_File (GNAT_Dir_Dl & "/hac/hac", GNAT_Dir & "/bin/hac");
               Sys.Shell_Execute ("chmod +x " & GNAT_Dir & "/bin/hac");
               if Fls.Create_Directory_Tree (GNAT_Dir & "/share/doc/hac") then
                  Fls.Copy_File (GNAT_Dir_Dl & "/hac/doc/HAC Ada Compiler User Manual.pdf", GNAT_Dir & "/share/doc/hac/HAC Ada Compiler User Manual.pdf");
               end if;
            end if;
         end if;
         
      else  
         Log.Msg (+"HAC already installed.");
      end if;
      
      --  Delete all documentation files, examples and download files if server install
      if (GNAT_Target = "server") then 
      
         if Fls.Delete_Directory_Tree (GNAT_Dir & "/share/doc") then
            Log.Msg (GNAT_Dir & "/share/doc" & " removed");
         end if;
      
         if Fls.Delete_Directory_Tree (GNAT_Dir & "share/examples") then
            Log.Msg (GNAT_Dir & "share/examples" & " removed");
         end if;
      
         if Fls.Delete_Directory_Tree (GNAT_Dir_Dl) then
            Log.Msg (GNAT_Dir_Dl & " removed");
         end if;
      
      end if;

      -- Restore current directory
      if not Fls.Set_Directory (Prg.Start_Dir) then
         Log.Err ("Srv.Install_Libraries - Can't return to origin directory.");
      end if;

   end Install_Libraries;
   
   ----------------------------------------------------------------------------
   procedure Remove_Libraries is
   begin
      
      --  AWS
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/aws") then
         Log.Msg (GNAT_Dir_Dl & "/aws" & " removed");
      end if;

      -- Zlib
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/zlib") then
         Log.Msg (GNAT_Dir_Dl & "/zlib" & " removed");
         Fls.Delete_File (GNAT_Dir & "/lib/libz.a");
      end if;
      
      -- Utilada
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/hac") then
         Log.Msg (GNAT_Dir_Dl & "/hac" & " removed");
         Fls.Delete_File (GNAT_Dir & "/bin/hac");
      end if;

      -- ASIS
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/asis") then
         Log.Msg (GNAT_Dir_Dl & "/asis" & " removed");
         Fls.Delete_File (GNAT_Dir & "/lib/asis/asislib/libasis.a");
      end if;
      
      -- AdaControl
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/adacontrol") then
         Log.Msg (GNAT_Dir_Dl & "/adacontrol" & " removed");
         Fls.Delete_File (GNAT_Dir & "/bin/adactl");
      end if;
      
      -- HAC
      if Fls.Delete_Directory_Tree (GNAT_Dir_Dl & "/hac") then
         Log.Msg (GNAT_Dir_Dl & "/hac" & " removed");
         Fls.Delete_File (GNAT_Dir & "/bin/hac");
      end if;
      
   end Remove_Libraries;
   
   ----------------------------------------------------------------------------
   procedure Help_Block_1 is
      pragma Style_Checks (Off); -- Can't strip columns
   begin
      Tio.Line;
      Tio.Put_Line ("Running AIDE without option will create a station install of GNAT CE");
      Tio.Put_Line (GNAT_Year & " with IDE to ~/opt/gnat-" & GNAT_Year & " with docs, tools and libraries.");
      Tio.Line;
      Tio.Put_Line ("AIDE is intended to be used on Debian, Ubuntu & derivatives");
      Tio.Put_Line ("distributions. You should first UPDATE & UPGRADE your system before");
      Tio.Put_Line ("using AIDE, as some additional packages could be installed.");
      Tio.Line;
   end Help_Block_1;
   
   ----------------------------------------------------------------------------
   procedure Help_Block_2 is
   begin
      Log.Msg ("--------------------------------------------------");
      Log.Msg ("To taking account of the PATH update:");
      Log.Msg ("- Close all terminals, including this one");
      Log.Msg ("- Run a fresh terminal with the updated PATH inside");
      Log.Msg ("/!\ Not follow this advice could rising problems.");
      Log.Msg ("--------------------------------------------------");
   end Help_Block_2;
   
-------------------------------------------------------------------------------   
end Srv;
-------------------------------------------------------------------------------
