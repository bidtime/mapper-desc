unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ToolWin,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    ToolBar1: TToolBar;
    Button1: TButton;
    StatusBar1: TStatusBar;
    MemoFiles: TMemo;
    Splitter1: TSplitter;
    memoTarget: TMemo;
    ToolButton1: TToolButton;
    Edit2: TEdit;
    Splitter2: TSplitter;
    MemoSrc: TMemo;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Masks;

{$R *.dfm}

// 遍历目录及子目录

procedure GetFileListEx(FilePath, ExtMask: string; FileList: TStrings;
  SubDirectory: Boolean = True);

  function Match(FileName: string; MaskList: TStrings): Boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to MaskList.Count - 1 do
    begin
      if MatchesMask(FileName, MaskList[i]) then
      begin
        Result := True;
        break;
      end;
    end;
  end;

var
  FileRec: TSearchRec;
  MaskList: TStringList;
begin
  if DirectoryExists(FilePath) then
  begin
    if FilePath[Length(FilePath)] <> '\' then
      FilePath := FilePath + '\';
    if FindFirst(FilePath + '*.*', faAnyFile, FileRec) = 0 then
    begin
      MaskList := TStringList.Create;
      try
        ExtractStrings([';'], [], PChar(ExtMask), MaskList);
        FileList.BeginUpdate;
        repeat
          if ((FileRec.Attr and faDirectory) <> 0) and SubDirectory then begin
            if (FileRec.Name <> '.') and (FileRec.Name <> '..') then
              GetFileListEx(FilePath + FileRec.Name + '\', ExtMask, FileList);
          end else begin
            if Match(FilePath + FileRec.Name, MaskList) then begin
              FileList.Add( FilePath + FileRec.Name);
            end;
          end;
        until FindNext(FileRec) <> 0;
        FileList.EndUpdate;
      finally
        MaskList.Free;
      end;
    end;
    FindClose(FileRec);
  end;
end;

function getFileTree(const filepath:string):TStringlist;
var
  sr:TSearchrec;
begin
   result:=TStringlist.Create;
   if Findfirst(filepath+'\*',faanyfile,sr)=0 then
   begin
     repeat
        if (sr.Name = '.') or (sr.Name='..') then continue;
        if sr.Attr = fadirectory then begin
          result.Add(sr.Name);
          result.AddStrings(getFileTree(filepath+'\'+sr.Name)) ;
        end else begin
          result.Add(sr.Name);
        end;
     until findnext(sr) <>0;
     findclose(sr);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);

  procedure readFile(const S: string; strs: TStrings);
  begin
    strs.LoadFromFile(S, TEncoding.UTF8);
  end;

  procedure writeFile(const S: string; strs: TStrings);
  begin
    strs.SaveToFile(S, TEncoding.UTF8);
  end;

  procedure getFiles();
  begin
    self.MemoFiles.Clear;
    self.MemoSrc.Clear;
    self.memoTarget.Clear;
    GetFileListEx(self.Edit1.Text, self.Edit2.Text, self.MemoFiles.Lines, true);
  end;

  procedure doIt(const strs: TStrings);

    function getMapperFileName(const S: string): string;
    var tmp: string;
    begin
      tmp := S.Replace('DAO.java', 'Mapper.java');
      Result := tmp;
    end;

    function processDAOFile(const fName: string; strsSrc, strsDest: TStrings; var imports: string): string;
    var S,desc: string;
      I: integer;
    begin
      desc := '';
      strsSrc.Clear;
      strsDest.Clear;
      //
      readFile(fName, strsSrc);
      for I := 0 to strsSrc.Count - 1 do begin
        S := strsSrc[I];
        if S.IndexOf('import com.ecarpo.bms.common.annotation.DAODescribe;')>=0 then begin
          imports := S;
          continue;
        end else if (S.indexOf('@DAODescribe')>=0) then begin
          desc := S;//.Replace('DAODescribe', 'MapperDesc');
          continue;
        end else begin
          strsDest.Add(S);
        end;
      end;
      //
      if not desc.IsEmpty then begin
        writeFile(fName, strsDest);
      end;
      Result := desc;
    end;

    function processMapperFile(const fName,desc,imports: string; strsSrc, strsDest: TStrings): string;

      function descReplace(const s: string; var rst: string): boolean;
      begin
        if s.isEmpty then begin
          Result := false;
        end else begin
          rst := S.Replace('DAODescribe', 'MapperDesc');
          Result := true;
        end;
      end;

    var S, rst: string;
      I: integer;
      addIt: boolean;
    begin
      strsSrc.Clear;
      strsDest.Clear;
      addIt := false;
      //
      readFile(fName, strsSrc);
      for I := 0 to strsSrc.Count - 1 do begin
        S := strsSrc[I];
        if (S.StartsWith('import')) then begin
          if not addIt then begin
            if descReplace(imports, rst) then begin
              strsDest.add(rst);
            end;
            addIt := true;
          end;
        end else if S.IndexOf('public interface')>=0 then begin
          if descReplace(desc, rst) then begin
            strsDest.Add(rst);
          end;
        end;
        strsDest.Add(S);
      end;
      //
      writeFile(fName, strsDest);
    end;

    function processMapperOfDAOFile(const daoFile,desc,imports: string; strsSrc, strsDest: TStrings): string;
    var
      mapperFile: string;
    begin
      mapperFile := getMapperFileName(daoFile);
      processMapperFile(mapperFile, desc, imports, strsSrc, strsDest);
    end;

  var I: integer;
    daoFile, desc, imports: string;
  begin
    for I := 0 to strs.Count - 1 do begin
      daoFile := strs[I];
      desc := processDAOFile(daoFile, self.MemoSrc.Lines, self.memoTarget.Lines, imports);
      if self.CheckBox1.Checked then begin
        if not desc.IsEmpty then begin
          processMapperOfDAOFile(daoFile, desc, imports, self.MemoSrc.Lines, self.memoTarget.Lines);
        end;
      end;
    end;
  end;

begin
  getFiles();
  doIt(self.MemoFiles.Lines);
end;

end.
