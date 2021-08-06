------------------------------------------------------------------------------
--  ▄▖▄▖▄ ▄▖
--  ▌▌▐ ▌▌▙▖
--  ▛▌▟▖▙▘▙▖
--
--  @file      aide.adb
--  @copyright Sowebio SARL - France
--  @licence   GPL v3
--  @encoding  UTF-8
------------------------------------------------------------------------------
--  @summary
--  AIDE - Ada Instant Development Environment for Debian/Ubuntu & derivatives
--
--  @description
--  ...
--
--  @authors
--  Stéphane Rivière - sr - sriviere@soweb.io
--
--  @versions
--  20210312 - 2.01 - sr - initial release under HAC. Major version number in
--                         memory of AIDE 1.x from the beginning of the 21st
--                         century :)
--  20210313 - 2.02 - sr - rename gnat-install to gnat-manage, make options
--                         action (install or remove) and year (2019 or 2020),
--                         new log file and help screen
--  20210314 - 2.03 - sr - total execution time
--  20210315 - 2.04 - sr - sudo when used by non root user, change logo
--                         header, better help screen
--  20210316 - 2.05 - sr - add .gpr mime and gpsYEAR.desktop registration to
--                         associate .gpr with GNAT Programming System IDE and
--                         gnome databases updating for instant readiness,
--                         replace all Shell_Exec ("rm...") by Delete_File ()
--  20210316 - 2.06 - sr - replace wget by curl to reduce verbosity, better
--                         user information and improve consistency with
--                         libcurl Ada use through Ada-Util
--  20210318 - 2.07 - sr - Fix GNAT PATH export string detection, vastly
--                         improve adacontrol installation process
--  20210405 - 2.08 - sr - Move Path update to the very beginning of the
--                         process to avoid interrupting the installation
--                         later. Now include HAC, a powerfull Ada Subset
--                         interpreter. Warns user to update+upgrade hise
--                         system. Change program nam from gnat-manage to aide
--                         for GNU/Linux Debian & Ubuntu
--  20210407 - 2.09 - sr - Add update libraries option, change whole logic
--                         around libraries as a side effect, fix somes bugs
--  20210407 - 2.10 - sr - First release under GNAT CE with v20 library.
--  20210412 - 2.11 - sr - Add activate and deactivate commands.
--  20210414 - 2.12 - sr - First public release
--  20210602 - 2.13 - sr - Create root GNAT directory if missing, typo on AIDE
--                         banner, fix a vicious bug in Install_GNAT_Path when 
--                         the last file line which is a commented one and not
--                         ending by a LF (new line) character thus the string
--                         is inserted at the end of the commented line 
--                         instead but wrote on a new line !
--  20210603 - 2.14 - sr - Full rework of installation strategy, as the QT
--                         installer used by GNATStudio is really a bad choice
--                         for unattended real non graphic servers targets. 
--                         New package command to create GNAT CE 2019/20/21
--                         ultra compressed packages (.xz format). Install
--                         command has now 3 ways to get install files :
--                         - Local generated packages;
--                         - Internet AIDE repository packages;
--                         - Adacore repository installers.
--  20210730 - 2.15 - sr - Finishes for production ready status. Fix many bugs.
--                         Rework messages, parameters, options and 
--                         documentation.
--  20210804 - 2.16 - sr - Fix a RTE when a program is launched through a 
--                         symbolic link. Add date build at the start banner.
--                         Fix a RTE (due to missing MIME) if a station install
--                         was done on a server target. This choice gives now
--                         an error message: "Error: Can't install a station 
--                         setup on a server target." Add a specific Linux 
--                         linker option to the HAC build line to handle full
--                         static build.
-------------------------------------------------------------------------------

with GNAT.Command_Line;
with GNAT.OS_Lib;
with GNAT.Strings;

with v20; use v20;
with v20.Vst; use v20.Vst;
with v20.Fls;
with v20.Sys;
with v20.Prg;
with v20.Tio;
with v20.Log;

procedure Aide is

   package GCL renames GNAT.Command_Line;
   package GOL renames GNAT.OS_Lib;
   package GS renames GNAT.Strings;

   ----------------------------------------------------------------------------
   --  PUBLIC VARIABLES AND CONSTANTS
   ----------------------------------------------------------------------------

   OS_Packages : constant String := "automake, make, curl, git, libtool, " &
             "tar, xz-utils, libcurl4, libcurl4-openssl-dev, libssl-dev, perl";

   GNAT_Target, GNAT_Year, GNAT_Dir, GNAT_Dir_Dl, AIDE_Action : VString := +"";
   GNAT_Dir_Root : constant VString := +"/opt/gnat-";

   Mime_Type : constant VString := +"x-adagpr";
   Mime_Application : constant VString := +"application";
   Mime_Type_Package_Name : constant VString := Sys.Get_Home &
                              "/.local/share/mime/packages/" &
                              Mime_Application & "-" & Mime_Type & ".xml";
                             
   --  Files to download
   
   type GNAT_To_Download is record
      Name : VString;
      Install_Url : VString;
      Install_Size : Natural;
      Server_Size : Natural;
      Station_Size : Natural;
   end record;
   
   AIDE_Root_Url_Download_Packs : constant String := "https://stef.genesix.org/pub/ada/aide/";
   AIDE_Install_Ok_File : constant String := "install_ok_dont_delete_this_file";

   GNAT_Download : array (2019 .. 2021) of GNAT_To_Download;

   --  Command line processing

   Install_Action : constant String := "install";
   Activate_Action : constant String := "activate";
   Deactivate_Action : constant String := "deactivate";
   Update_Action : constant String := "update";
   Remove_Action : constant String := "remove";
   List_Action : constant String := "list";
   Package_Action : constant String := "package";

   Config : GCL.Command_Line_Configuration;

   ----------------------------------------------------------------------------
   --  PROCEDURES & FUNCTIONS
   ----------------------------------------------------------------------------

   --  Declare first proc/func of the parent body (this file)

   --  Parent body proc/func must be declared <here> (actually none)

   --  Then declare the separate body proc/func so that the functions of the
   --  parent body (this file) are visible from the separate body
   package Srv is

      procedure Install_Registering (Year_Install : VString);
      --  Create GPS and register launcher file, register MIME type.
      procedure Remove_Registering (Year_Install : VString);
      --  Remove GPS and register launcher file, deregister MIME type.
      function Remove_Registering_All_Years return Boolean;
      --  Delete all registerings and paths for all years?
      function Install_GNAT_Script (File_Name : VString) return Boolean;
      --  Create install script with "create" or "delete" operation.
      function Install_GNAT_Path (Dir_Install : VString) return Boolean;
      --  Set GNAT path.
      function Install_GNAT_Debug_RTS (Year_Install : VString) return Boolean;
      --  Install Debug ready run-time system
      function Install_GNAT_Pack (File_Pack : VString) return Boolean;
      --  Install GNAT pack
      function Install_GNAT (Year_Install : VString) return Boolean;
      --  Install GNAT community edition.
   procedure Create_GNAT_Pack_Files (File_Install : VString;
                                     Year_Install : VString;
                                     Dir_Install : VString;
                                     Type_Install : VString;
                                     Build_Install : VString);
      --  Create GNAT pack files, Type install is +"server" or +"station".
      procedure Create_GNAT_Pack (Year_Install : VString);
      --  Create GNAT pack
      procedure Remove_GNAT;
      --  Remove GNAT community edition.
      procedure Install_Libraries (Year_Install : VString);
      --  Install libraries
      procedure Remove_Libraries;
      --  Remove librairies
      procedure Help_Block_1;
      --  Additional Help.
      procedure Help_Block_2;
      --  Additional Help.
   end Srv;
   package body Srv is separate;

   ----------------------------------------------------------------------------
   --  Main program
   ----------------------------------------------------------------------------

begin

   --  Main settings

   Prg.Set_Version (2, 16);
   Log.Set_Debug (False);

   --  Memory monitor

   Sys.Set_Memory_Monitor (True);
   Log.Dbg (Sys.Get_Alloc_Ada);
   Log.Dbg (sys.Get_Alloc_All);

   --  Header

   Log.Line;
   Log.Msg ("AIDE - Ada Instant Development Environment");
   Log.Msg ("Copyright (C) Sowebio SARL 2020-2021, according to GPLv3.");
   Log.Msg (Prg.Get_Version & " - " & v20.Get_Version & " - " & v20.Get_Build);
   Log.Line;
   
   --  Files to download 
   --  No integrity check as install or decompress check already exists

   --  2019
   GNAT_Download(2019).Name := +"gnat-2019-20190517-linux64";    
   
   GNAT_Download(2019).Install_Url := +"https://community.download.adacore.com/v1/" & 
                       "0cd3e2a668332613b522d9612ffa27ef3eb0815b?filename=" &
                       "gnat-community-2019-20190517-x86_64-linux-bin";
   GNAT_Download(2019).Install_Size := 516626663;
   GNAT_Download(2019).Server_Size := 179628304;
   GNAT_Download(2019).Station_Size := 453426880;
   
   --  2020
   GNAT_Download(2020).Name := +"gnat-2020-20200429-linux64";
   
   GNAT_Download(2020).Install_Url := +"https://community.download.adacore.com/v1/" & 
                       "4d99b7b2f212c8efdab2ba8ede474bb9fa15888d?filename=" &
                       "gnat-2020-20200429-x86_64-linux-bin";
   GNAT_Download(2020).Install_Size := 661178129;       
   GNAT_Download(2020).Server_Size := 190787452;
   GNAT_Download(2020).Station_Size := 563875324;

   --  2021 
   GNAT_Download(2021).Name := +"gnat-2021-20210519-linux64";  
      
   GNAT_Download(2021).Install_Url := +"https://community.download.adacore.com/v1/" & 
                       "f3a99d283f7b3d07293b2e1d07de00e31e332325?filename=" &
                       "gnat-2021-20210519-x86_64-linux-bin";
   GNAT_Download(2021).Install_Size := 754890671;       
   GNAT_Download(2021).Server_Size := 202068476;
   GNAT_Download(2021).Station_Size := 636251504;

   --  Command line processing ------------------------------------------------

      declare

      Gcl_Target : aliased GS.String_Access;
      Gcl_Install : aliased GS.String_Access;
      Gcl_Year : aliased Integer := 0;
      Gcl_Check : aliased Boolean := False;
      
      Arg_Count : Natural := 0;
      Arg_Last, Arg_Not_Valid : Boolean := False;
      Arg_Max : constant Natural := 10;
      type Arg_Table_Lines is array (1 .. Arg_Max) of VString;
      Arg_Table : Arg_Table_Lines;

   begin

      --  Usage

      GCL.Set_Usage (Config,
              Usage => "[" & Install_Action & "]" &
                     "|" & Activate_Action &
                     "|" & Deactivate_Action &
                     "|" & Update_Action &
                     "|" & Remove_Action &
                     "|" & List_Action &
                     "|" & Package_Action &
                     " [options]");

      --  Switchs without arguments (none)

      --  Switchs with arguments

      GCL.Define_Switch (Config, Gcl_Target'Access,
                         Switch => "-t=",
                         Long_Switch => "--target=",
                         Argument => "TARGET",
                         Help => "server|[station] with graphic IDE");
      GCL.Define_Switch (Config, Gcl_Install'Access,
                         Switch => "-i=",
                         Long_Switch => "--install=",
                         Argument => "DIRECTORY",
              Help => "[~/opt/gnat-YEAR] or home based custom sub-directory");
      GCL.Define_Switch (Config, Gcl_Year'Access,
                         Switch => "-y=",
                         Long_Switch => "--year=",
                         Argument => "YEAR",
                         Help => "2019|2020|[2021] GNAT CE Year edition");
      GCL.Define_Switch (Config, Gcl_Check'Access,
                         Switch => "-c",
                         Help => "Check .err trace raising an exception");

      --  Command line loading

      GCL.Getopt (Config);

      --  Arguments processing

      while not Arg_Last and Arg_Count + 1 < Arg_Max loop
         Arg_Table (Arg_Count + 1) :=
                  To_Lower (GCL.Get_Argument (End_Of_Arguments => Arg_Last));
         if not Arg_Last and Length (Arg_Table (Arg_Count + 1)) > 0 then
            Arg_Count := Arg_Count + 1;
         end if;
      end loop;

      Log.Dbg ("Args count: " & To_VString (Arg_Count));

      --  No argument (allowed) => Default(s) argument(s)
      if Arg_Count = 0 then
         AIDE_Action := To_VString (Install_Action);
      --  1st argument (allowed) => process argument
      elsif Arg_Count = 1 then
         if (Arg_Table (Arg_Count) = Install_Action) or
            (Arg_Table (Arg_Count) = Activate_Action) or
            (Arg_Table (Arg_Count) = Deactivate_Action) or
            (Arg_Table (Arg_Count) = Update_Action) or
            (Arg_Table (Arg_Count) = Remove_Action) or
            (Arg_Table (Arg_Count) = List_Action) or
            (Arg_Table (Arg_Count) = Package_Action)
         then
            AIDE_Action := Arg_Table (Arg_Count);
         else
            Arg_Not_Valid := True;
         end if;
      --  Others cases (forbidden)
      else
         Arg_Not_Valid := True;
      end if;

      Log.Dbg ("AIDE_Action: " & AIDE_Action);

      --  Switch processing

      if Gcl_Target.all = "" then
         GNAT_Target := +"station";
      elsif Gcl_Target.all = "station" or Gcl_Target.all = "server" then
         GNAT_Target := To_VString (Gcl_Target.all);
      else
         Arg_Not_Valid := True;
      end if;
      Log.Dbg ("Switch -t: " & GNAT_Target);

      if Gcl_Year = 0 then
         GNAT_Year := +"2021";
      elsif Gcl_Year = 2019 or
            Gcl_Year = 2020 or
            Gcl_Year = 2021
      then
         GNAT_Year := To_VString (Gcl_Year);
      else
         Arg_Not_Valid := True;
      end if;
      Log.Dbg ("Switch -y: " & GNAT_Year);

      if Gcl_Install.all = "" then
         GNAT_Dir := Sys.Get_Home & GNAT_Dir_Root & GNAT_Year;
      else
         GNAT_Dir :=
            Sys.Get_Home & "/" & Trim_Slashes (To_VString (Gcl_Install.all));
      end if;
      Log.Dbg ("Switch -i: " & GNAT_Dir);
      
      if Gcl_Check then   ----------------------------------------------/\-----
         Raise_Exception; --  < Crash program to test .err trace       /!!\
      end if;             --------------------------------------------/-!!-\---

      -- Check graphic station or text mode server (to avoid MIME RTE)
      if (not Fls.Exists (+"/usr/share/xsessions")) and (GNAT_Target = +"station") then
         Log.Msg (+"Error: Can't install a station setup on a server target.");
         Log.Line;
         Arg_Not_Valid := True;
      end if;

      GNAT_Dir_Dl := GNAT_Dir & "-downloads";

      if Arg_Not_Valid then
         GCL.Display_Help (Config);
         raise GCL.Invalid_Switch;
      end if;

   end;

   --  Real program start -----------------------------------------------------

   if Prg.Is_User_Not_Root and (AIDE_Action = Install_Action) then
      Log.Msg ("You are not logged as root.");
      Log.Msg ("Your password will be asked if new packages are needed.");
      Log.Line;
   end if;

   if not (AIDE_Action = List_Action) then
      if (AIDE_Action = Package_Action) then
         Log.Msg ("Do you wish to " & To_Upper (AIDE_Action) &
                  " all GNAT CE years to " & Sys.Get_Home & GNAT_Dir_Root &
                  "20NN-packages target ?");
      elsif (AIDE_Action = Deactivate_Action) then
         Log.Msg ("Do you wish to " & To_Upper (AIDE_Action) & " GNAT CE " &
                 GNAT_Year & " for all GNAT CE years installed ?");
      else
         Log.Msg ("Do you wish to " & To_Upper (AIDE_Action) & " GNAT CE " &
                 GNAT_Year & " for " & To_Upper (GNAT_Target) & " target ?");
      end if;
      Tio.Pause;
      Log.Line;
      Log.Line;
   end if;

   Log.Set_Header (True);
   Log.Set_Disk (True);

   Log.Title ("");
   Log.Dbg (Sys.Get_Alloc_Ada);
   Log.Dbg (Sys.Get_Alloc_All);

   if AIDE_Action = Install_Action then
      Log.Set_Task (+"INSTALL");
      if not Fls.Exists (GNAT_Dir & "/" & AIDE_Install_Ok_File) then
         if Srv.Install_GNAT_Path (GNAT_Dir) then
            if Sys.Install_Packages (OS_Packages) then
               if Fls.Create_Directory_Tree (GNAT_Dir_Dl) then
                  if Srv.Install_GNAT (GNAT_Year) then
                     --  Remove only if install successful
                     if Srv.Remove_Registering_All_Years then
                        -- Rewrite PATH in .bashrc for the installed year only 
                        if Srv.Install_GNAT_Path (GNAT_Dir) then
                           Srv.Install_Registering (GNAT_Year);
                           Srv.Install_Libraries (GNAT_Year);
                        end if;
                     end if;
                  end if;
               else
                  Log.Err ("Aide - Can't create installation directory.");
               end if;
            else
               Log.Err ("Aide - Can't install system packages.");
            end if;
         end if;
      else
         Log.Msg ("GNAT CE " & GNAT_Year & " is already installed.");
      end if;

   elsif AIDE_Action = Activate_Action then
      Log.Set_Task (Slice (GNAT_Year, 3, 4) & " ON");

      if Srv.Remove_Registering_All_Years then
         Srv.Install_Registering (GNAT_Year);
         if Srv.Install_GNAT_Path (GNAT_Dir) then
            Log.Msg ("GNAT CE " & GNAT_Year & " is already activated.");
            
         end if;
      else
         Log.Msg ("GNAT CE " & GNAT_Year & " is not installed.");
      end if;

   elsif AIDE_Action = Deactivate_Action then
      Log.Set_Task (Slice (GNAT_Year, 3, 4) & " OFF");

      if Srv.Remove_Registering_All_Years then
         Srv.Help_Block_2;
      else
         Log.Msg ("GNAT CE " & GNAT_Year & " is not installed.");
      end if;

   elsif AIDE_Action = Update_Action then
      Log.Set_Task ("UPDATE");

      Srv.Remove_Libraries;
      Srv.Install_Libraries (GNAT_Year);

   elsif AIDE_Action = Remove_Action then
      Log.Set_Task ("REMOVE");

      if Fls.Exists (GNAT_Dir & "/" & AIDE_Install_Ok_File) then
         Srv.Remove_GNAT;
         Srv.Remove_Registering (GNAT_Year);
         Fls.Delete_Lines (Sys.Get_Home & "/.bashrc", To_String
                   (Sys.Get_Home & GNAT_Dir_Root & GNAT_Year & "/bin:$PATH"));
         Srv.Help_Block_2;
      else
         Log.Msg ("GNAT CE " & GNAT_Year & " is not installed.");
      end if;

   elsif AIDE_Action = List_Action then
      Log.Set_Task ("LIST");

      declare
         Report : VString := +"";
         Found : Boolean := False;
      begin
         Log.Msg ("GNAT Compiler    Activated  Location");

         for I in 2019 .. 2021 loop
            if Fls.Exists (Sys.Get_Home & GNAT_Dir_Root & To_VString (I) & "/" & AIDE_Install_Ok_File) then
               Report := "AdaCore CE " & To_VString (I);
               Found := True;
               if Fls.Search_Lines (Sys.Get_Home & "/.bashrc",
                                 To_String (Sys.Get_Home & GNAT_Dir_Root &
                                        To_VString (I) & "/bin:$PATH"))
               then
                  Report := Report & (2 * " ") & "Yes";
               else
                  Report := Report & (5 * " ");
               end if;
               Report := Report & (8 * " ") & Sys.Get_Home &
                                              GNAT_Dir_Root & To_VString (I);
               Log.Msg (Report);
            end if;
         end loop;
         if not Found then
            Log.Msg (+"None installed");
         end if;
      end;
      
   elsif AIDE_Action = Package_Action then
      Log.Set_Task ("PACKAGE");
   
      -- Srv.Create_GNAT_Pack (+"2021"); -- Debug 
      for I in GNAT_Download'Range loop
         Srv.Create_GNAT_Pack (To_VString (I));
      end loop;
      
   end if;

   Log.Set_Task (+"EXIT");

   if not (AIDE_Action = List_Action) then
      Log.Msg ("Total execution time: " & Prg.Duration_Stamp (Prg.Start_Time));
   end if;

   --  Memory monitor

   Log.Dbg (Sys.Get_Alloc_Ada);
   Log.Dbg (Sys.Get_Alloc_All);
   Log.Title ("");
   Log.Set_Disk (False);
   Log.Line;

exception

   --  -h or --help switches
   when GCL.Exit_From_Command_Line =>
      Srv.Help_Block_1;
      GOL.OS_Exit (1);

   --  Invalid switches
   when GCL.Invalid_Switch =>
      Srv.Help_Block_1;
      GOL.OS_Exit (2);

   --  Invalid switches
   when GCL.Invalid_Parameter =>
      GCL.Display_Help (Config);
      Srv.Help_Block_1;
      GOL.OS_Exit (3);

   --  Runtime errors
   when Error : others =>
      v20.Exception_Handling (Error);

-------------------------------------------------------------------------------
end Aide;
-------------------------------------------------------------------------------
