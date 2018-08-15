unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    PaintBox1: TPaintBox;
    Shape1: TShape;

    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

      procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
  private
  public
    //return true if it can draw it
    function DrawCell(ACanvas:TCanvas; x, y, w, h, index: Integer): Boolean;
    //Calc index of cell of array from x and y
    //return true if we find a cell , not empty space
    function PointToIndex(x, y: Integer; var Col, Row, Index: Integer): Boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

const
  ColCount: Integer = 10;
  //RowCount: Integer = 10; no need it

  DarkColorArray: Array[0..195] Of TColor = (clBlack, $000F0000, $001E0000, $002D0000, $003C0000, $004B0000, $00000F00, $000F0F00, $001E0F00, $002D0F00, $003C0F00, $004B0F00, $00001E00, $000F1E00, $001E1E00, $002D1E00, $003C1E00, $004B1E00, $00002D00, $000F2D00, $001E2D00, $002D2D00, $003C2D00, $004B2D00, $00003C00, $000F3C00, $001E3C00, $002D3C00, $003C3C00, $004B3C00, $00004B00, $000F4B00, $001E4B00, $002D4B00, $003C4B00, $004B4B00, $0000000F, $000F000F, $001E000F, $002D000F, $003C000F, $004B000F, $00000F0F, $000F0F0F, $001E0F0F, $002D0F0F, $003C0F0F, $004B0F0F, $00001E0F, $000F1E0F, $001E1E0F, $002D1E0F, $003C1E0F, $004B1E0F, $00002D0F, $000F2D0F, $001E2D0F, $002D2D0F, $003C2D0F, $004B2D0F, $00003C0F, $000F3C0F, $001E3C0F, $002D3C0F, $003C3C0F, $004B3C0F, $00004B0F, $000F4B0F, $001E4B0F, $002D4B0F, $003C4B0F, $004B4B0F, $0000001E, $000F001E, $001E001E, $002D001E, $003C001E, $004B001E, $00000F1E, $000F0F1E, $001E0F1E, $002D0F1E, $003C0F1E, $004B0F1E, $00001E1E, $000F1E1E, $001E1E1E, $002D1E1E, $003C1E1E, $004B1E1E, $00002D1E, $000F2D1E, $001E2D1E, $002D2D1E, $003C2D1E, $004B2D1E, $00003C1E, $000F3C1E, $001E3C1E, $002D3C1E, $003C3C1E, $004B3C1E, $00004B1E, $000F4B1E, $001E4B1E, $002D4B1E, $003C4B1E, $004B4B1E, $0000002D, $000F002D, $001E002D, $002D002D, $003C002D, $004B002D, $00000F2D, $000F0F2D, $001E0F2D, $002D0F2D, $003C0F2D, $004B0F2D, $00001E2D, $000F1E2D, $001E1E2D, $002D1E2D, $003C1E2D, $004B1E2D, $00002D2D, $000F2D2D, $001E2D2D, $002D2D2D, $003C2D2D, $00003C2D, $000F3C2D, $001E3C2D, $002D3C2D, $003C3C2D, $00004B2D, $000F4B2D, $001E4B2D, $0000003C, $000F003C, $001E003C, $002D003C, $003C003C, $004B003C, $00000F3C, $000F0F3C, $001E0F3C, $002D0F3C, $003C0F3C, $004B0F3C, $00001E3C, $000F1E3C, $001E1E3C, $002D1E3C, $003C1E3C, $004B1E3C, $00002D3C, $000F2D3C, $001E2D3C, $002D2D3C, $003C2D3C, $00003C3C, $000F3C3C, $001E3C3C, $002D3C3C, $00004B3C, $000F4B3C, $001E4B3C, $0000004B, $000F004B, $001E004B, $002D004B, $003C004B, $004B004B, $00000F4B, $000F0F4B, $001E0F4B, $002D0F4B, $003C0F4B, $004B0F4B, $00001E4B, $000F1E4B, $001E1E4B, $002D1E4B, $003C1E4B, $004B1E4B, $00002D4B, $000F2D4B, $001E2D4B, $00003C4B, $000F3C4B, $001E3C4B, $00004B4B, $000F4B4B, $001E4B4B  );
  BrightColorArray: Array[0..236] Of TColor = ($00F50000, $00F52300, $00F54600, $00F56900, $00F58C00, $00F5AF00, $00F5D200, $0000F500, $0023F500, $0046F500, $0069F500, $008CF500, $00AFF500, $00D2F500, $00F5F500, $00F50023, $00F52323, $00F54623, $00F56923, $00F58C23, $00F5AF23, $00F5D223, $0000F523, $0023F523, $0046F523, $0069F523, $008CF523, $00AFF523, $00D2F523, $00F5F523, $00F50046, $00F52346, $00D24646, $00F54646, $00D26946, $00F56946, $00D28C46, $00F58C46, $00D2AF46, $00F5AF46, $0046D246, $0069D246, $008CD246, $00AFD246, $00D2D246, $00F5D246, $0000F546, $0023F546, $0046F546, $0069F546, $008CF546, $00AFF546, $00D2F546, $00F5F546, $00F50069, $00F52369, $00D24669, $00F54669, $00D26969, $00F56969, $00D28C69, $00F58C69, $00D2AF69, $00F5AF69, $0046D269, $0069D269, $008CD269, $00AFD269, $00D2D269, $00F5D269, $0000F569, $0023F569, $0046F569, $0069F569, $008CF569, $00AFF569, $00D2F569, $00F5F569, $00F5008C, $00F5238C, $00D2468C, $00F5468C, $00D2698C, $00F5698C, $00AF8C8C, $00D28C8C, $00F58C8C, $008CAF8C, $00AFAF8C, $00D2AF8C, $00F5AF8C, $0046D28C, $0069D28C, $008CD28C, $00AFD28C, $00D2D28C, $00F5D28C, $0000F58C, $0023F58C, $0046F58C, $0069F58C, $008CF58C, $00AFF58C, $00D2F58C, $00F5F58C, $00F500AF, $00F523AF, $00D246AF, $00F546AF, $00D269AF, $00F569AF, $008C8CAF, $00AF8CAF, $00D28CAF, $00F58CAF, $008CAFAF, $00AFAFAF, $00D2AFAF, $00F5AFAF, $0046D2AF, $0069D2AF, $008CD2AF, $00AFD2AF, $00D2D2AF, $00F5D2AF, $0000F5AF, $0023F5AF, $0046F5AF, $0069F5AF, $008CF5AF, $00AFF5AF, $00D2F5AF, $00F5F5AF, $00F500D2, $00F523D2, $004646D2, $006946D2, $008C46D2, $00AF46D2, $00D246D2, $00F546D2, $004669D2, $006969D2, $008C69D2, $00AF69D2, $00D269D2, $00F569D2, $00468CD2, $00698CD2, $008C8CD2, $00AF8CD2, $00D28CD2, $00F58CD2, $0046AFD2, $0069AFD2, $008CAFD2, $00AFAFD2, $00D2AFD2, $00F5AFD2, $0046D2D2, $0069D2D2, $008CD2D2, $00AFD2D2, $00D2D2D2, $00F5D2D2, $0000F5D2, $0023F5D2, $0046F5D2, $0069F5D2, $008CF5D2, $00AFF5D2, $00D2F5D2, $00F5F5D2, $000000F5, $002300F5, $004600F5, $006900F5, $008C00F5, $00AF00F5, $00D200F5, $00F500F5, $000023F5, $002323F5, $004623F5, $006923F5, $008C23F5, $00AF23F5, $00D223F5, $00F523F5, $000046F5, $002346F5, $004646F5, $006946F5, $008C46F5, $00AF46F5, $00D246F5, $00F546F5, $000069F5, $002369F5, $004669F5, $006969F5, $008C69F5, $00AF69F5, $00D269F5, $00F569F5, $00008CF5, $00238CF5, $00468CF5, $00698CF5, $008C8CF5, $00AF8CF5, $00D28CF5, $00F58CF5, $0000AFF5, $0023AFF5, $0046AFF5, $0069AFF5, $008CAFF5, $00AFAFF5, $00D2AFF5, $00F5AFF5, $0000D2F5, $0023D2F5, $0046D2F5, $0069D2F5, $008CD2F5, $00AFD2F5, $00D2D2F5, $00F5D2F5, $0000F5F5, $0023F5F5, $0046F5F5, $0069F5F5, $008CF5F5, $00AFF5F5, $00D2F5F5, $00F5F5F5 );

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin

end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, Row, Index: Integer;
begin
  if PointToIndex(X, Y, Col, Row, Index) then
  begin
    edit1.Text := Format('col %d row %d index %d', [Col, Row, Index]);
  end;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  RowCount: Integer; //as its name
  w, h: Integer; //width and height of cell

  l: Integer; //length of array
  x, y: Integer; //col and row
  c, r: Integer; //col and row
  index: integer; //index color in array;
begin
  with PaintBox1 do
  begin
    //this part here we calc needed variable
    //-----------------------------------------
    l := length(BrightColorArray);

    //first need to calc RowCount
    RowCount := l div ColCount;
    if (l mod ColCount) > 0 then //there is a uncompleted row
      Inc(RowCount);

    //Now we need to calc the hight of cell and the width of it
    w := ClientWidth div ColCount;// maybe we will lose some pixle we will ignore it
    h := ClientHeight div RowCount;//
    //-----------------------------------------

    index := 0;

    y := 0;
    for r := 0 to RowCount -1 do
    begin
      x := 0; //init x here on every time need to draw row
      for c := 0 to ColCount - 1 do
      begin
        DrawCell(Canvas, x, y, w, h, index); //notice it is canvas of paintbox, we r using "With"
        x := x + w;
        index := index + 1;
      end;
      y := y + h;
    end;
  end;
end;

function TForm1.PointToIndex(x, y: Integer; var Col, Row, Index: Integer): Boolean;
var
  RowCount: Integer;
  w, h: Integer;
  l: Integer;

begin
  //this part here we calc needed variable copued from top better to move it into function
  //-----------------------------------------
  l := length(BrightColorArray);

  //first need to calc RowCount
  RowCount := l div ColCount;
  if (l mod ColCount) > 0 then //there is a uncompleted row
    Inc(RowCount);

  //Now we need to calc the hight of cell and the width of it
  w := ClientWidth div ColCount;// maybe we will lose some pixle we will ignore it
  h := ClientHeight div RowCount;//
  //-----------------------------------------

  Row := (y div h);
  if (y mod h) > 0 then //if there is a rest that mean we are in middle of row, we need to add 1
    Inc(Row);

  Col := x div w;

  Index := Row * ColCount + Col; //yes index is easy
end;

function TForm1.DrawCell(ACanvas: TCanvas; x, y, w, h, index: Integer): Boolean;
begin
  Result := Index < length(BrightColorArray);
  if Result then
    ACanvas.Rectangle(x, y, x + w, y + h);
end;


end.

