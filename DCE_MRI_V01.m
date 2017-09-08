function varargout = DCE_MRI_V01(varargin)
% DCE_MRI_V01 MATLAB code for DCE_MRI_V01.fig
%      DCE_MRI_V01, by itself, creates a new DCE_MRI_V01 or raises the existing
%      singleton*.
%
%      H = DCE_MRI_V01 returns the handle to a new DCE_MRI_V01 or the handle to
%      the existing singleton*.
%
%      DCE_MRI_V01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DCE_MRI_V01.M with the given input arguments.
%
%      DCE_MRI_V01('Property','Value',...) creates a new DCE_MRI_V01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DCE_MRI_V01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DCE_MRI_V01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
 
% Edit the above text to modify the response to help DCE_MRI_V01
 
% Last Modified by GUIDE v2.5 21-Sep-2016 07:04:50
 
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DCE_MRI_V01_OpeningFcn, ...
                   'gui_OutputFcn',  @DCE_MRI_V01_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end
 
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
 
% --- Executes just before DCE_MRI_V01 is made visible.
function DCE_MRI_V01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DCE_MRI_V01 (see VARARGIN)
 
% Choose default command line output for DCE_MRI_V01
handles.output = hObject;
 
% Update handles structure
guidata(hObject, handles);
 
% UIWAIT makes DCE_MRI_V01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
 
axes(handles.axes5);
imshow('logo4.png');
axes(handles.axes6);
imshow('logo1.png');
axes(handles.axes1);
imshow('');
axes(handles.axes2);
imshow('');
axes(handles.axes3);
imshow('');
axes(handles.axes4);
imshow('');

 
 
function varargout = DCE_MRI_V01_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Get default command line output from handles structure
varargout{1} = handles.output;
 
 
% --------------------------------------------------------------------
function New_Callback(hObject, eventdata, handles)
% hObject    handle to New (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function Untitled_3_Callback(~, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
 
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit4_Callback(~, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 
function edit6_Callback(hObject, eventdata, ~)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
% --- Executes on button press in loadaif.
 
function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
 
 
% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
 
 
 

% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function view_Callback(hObject, eventdata, handles)
% hObject    handle to view (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function document_Callback(hObject, eventdata, handles)
% hObject    handle to document (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function cmap_Callback(hObject, eventdata, handles)
% hObject    handle to cmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function zoomin_Callback(hObject, eventdata, handles)
% hObject    handle to zoomin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function zoomout_Callback(hObject, eventdata, handles)
% hObject    handle to zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function wlevel_Callback(hObject, eventdata, handles)
% hObject    handle to wlevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
 
% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
close all;
% --- Executes on button press in pushbutton3.
 
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
 
 
% --------------------------------------------------------------------
function new_Callback(hObject, eventdata, handles)
% hObject    handle to new (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1,'string',''); 
set(handles.edit2,'string',''); 
set(handles.edit3,'string',''); 
set(handles.edit4,'string',''); 
set(handles.edit5,'string',''); 
set(handles.edit6,'string',''); 
set(handles.edit7,'string',''); 
set(handles.edit9,'string','');
set(handles.text18,'string','');
axes(handles.axes1);
imshow('');
 
 
% --- Executes on key press with focus on edit1 and none of its controls.
 
 
% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over edit1.
function edit1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%a=get([handles.edit1],'String');
% if(a=='a')
%     
%     set(handles.text13,'String','OK');
%   
% else
%     
%     set(handles.text13,'String','Not OK');
%     %beep;
% end
% function edit1_KeyPressFcn(hObject, eventdata, handles)
% list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
% 
% a=get([handles.edit1],'String');
% x=strmatch(a,list1);
%     if(x>=1)
%       
%         set(handles.text13,'String','strin ');
%     else
%              set(handles.text13,'String',' ');
%            
%     end
%get([handles.edit1],'String');
 
 
% --- Executes on key press with focus on edit1 and none of its controls.
function edit1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
%y=str2num(eventdata.Key);
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if(isempty(y)) 
        set(handles.text13,'String','* Please Enter the valid Ktrans data. [Range : 0-10]');
        set(handles.text22,'String','*');
else   
         set(handles.text13,'String',' ');
         set(handles.text22,'String',' '); 
         
end
 
% --- Executes during object creation, after setting all properties.
 
% --- Executes on key press with focus on edit2 and none of its controls.
function edit2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(double(eventdata.Key),double('@'))   
         set(handles.text13,'String','* Please Enter the valid Kep data. [Range : 0-5000]');
         set(handles.text24,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text24,'String',' ');
end
 
 
% --- Executes on key press with focus on edit3 and none of its controls.
function edit3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
 
a=get([handles.edit3],'String');
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')   
         set(handles.text13,'String','* Please Enter the valid Ktrans data. [Range : 0-10]');
         set(handles.text21,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text21,'String',' ');
end
 
 
% --- Executes on key press with focus on edit4 and none of its controls.
function edit4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
 
a=get([handles.edit4],'String');
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')   
         set(handles.text13,'String','* Please Enter the valid Kep data. [Range : 0-5000]');
         set(handles.text23,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text23,'String',' ');
end
 
 
% --- Executes on key press with focus on edit5 and none of its controls.
function edit5_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
 
a=get([handles.edit5],'String');
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')   
         set(handles.text13,'String','* Please Enter the valid Ktrans data. [Range : 0-10]');
         set(handles.text19,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text19,'String',' ');
end
 
 
% --- Executes on key press with focus on edit6 and none of its controls.
function edit6_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
 
a=get([handles.edit6],'String');
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')   
         set(handles.text13,'String','* Please Enter the valid Kep data. [Range : 0-5000]');
         set(handles.text20,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text20,'String',' ');
end
 
 
% --- Executes on key press with focus on edit8 and none of its controls.
function edit7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
 
%a=str2num(get([handles.edit7],'String');
x=strmatch(eventdata.Key,list1);
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')   
         set(handles.text13,'String','* Please Enter the valid Tacq data');
         set(handles.text25,'String','*');
else
         set(handles.text13,'String',' ');
         set(handles.text25,'String',' ');
end
 
% --- Executes on key press with focus on edit9 and none of its controls.
function edit9_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%   Key: name of the key that was pressed, in lower case
%   Character: character interpretation of the key(s) that was pressed
%   Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
 %Time_var=handles.Time_var;
list1 = {'~','`','!','@','#','$','%','^','&','*','(',')','-','_','+','+','{','}','[',']',':',';','"','<','>','?','/','\','|','''',',','.','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

x=strmatch(eventdata.Key,list1);
% A1=isa(eventdata.Key,'numeric');
if(length(x)>=1)
%if strcmpi(eventdata.Key,'a')
% n=isa(1,'numeric');
%     if(n==1)
         set(handles.text13,'String','Please Enter the Temporal Resolution');
         set(handles.text27,'String','*');   
else 
        
         set(handles.text13,'String',' ');
         set(handles.text27,'String',' '); 
      
    end
 
 
% --- Executes on key press with focus on edit7 and none of its controls.
 
 
% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
N(:,:,:)=handles.N(:,:,:);
D=handles.D;

sliderMin = 1;
sliderMax = length(D);
sliderStep = [1, 1]/(sliderMax - sliderMin);

set(handles.slider1, 'Min', sliderMin);
set(handles.slider1, 'Max', sliderMax);
set(handles.slider1, 'SliderStep', sliderStep);
currentSlice = int32(get(hObject,'Value'));
axes(handles.axes2);
imagesc(N(:,:,currentSlice),'Parent',handles.axes2);
set(handles.text32,'String', currentSlice);
        s=D(currentSlice).name;
        set(handles.text33, 'String', s);
        
        
        handles.sliderMin=sliderMin;
%         handles.s1=s;
        handles.currentSlice=currentSlice;
        handles.sliderMax=sliderMax;
         guidata(hObject,handles);
%set(handles.text33,'String', D.name);
% colormap(jet);
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)

dname = uigetdir('C:\Program Files\MATLAB\R2012a\bin\Qiba_v8');
D=dir(strcat(dname,'\*.dcm'));

    for i=1:length(D);
            R=dicomread(fullfile(dname,D(i).name));
            N(:,:,i)=R;
        %imagesc(R);pause(5)
    end
   %% 
%         x = inputdlg('Enter the image number :');
%         data = str2double(x); 
        imagesc(N(:,:,1),'Parent', handles.axes2);
        colormap(jet);

  
    
    %% Test
%     var1 = get(handles.text4,'String');
%     handles.var1 = var1;
%     guidata(hObject,handles);
    %%
    handles.D=D;
    handles.R=R;
    handles.N(:,:,:) = N(:,:,:);
    handles.dname=dname;
    guidata(hObject,handles);

% --- Executes on button press in togglebutton2.
%{
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N(:,:,:)=handles.N(:,:,:);
R=handles.R;
D=handles.D;
dname=handles.dname;
% currentSlice=handles.currentSlice;
% s=handles.s;
a=imread('pausebutton.png');
b=imread('playbutton.png');
n=get(hObject,'Value');
set(handles.slider1,'Value',1);

 if n==1
            set(hObject,'CData',a);
            for i=1:length(D);
                if n==0
                    set(hObject,'CData',b);
                    axes(handles.axes2);
                    pause(inf);
                end

                R=dicomread(fullfile(dname,D(i).name));
                N(:,:,i)=R;
                axes(handles.axes2);
                imagesc(R);pause(0.09);        
                set(handles.text33, 'String', D(i).name);
                set(handles.text32, 'String', i);
                set(handles.slider1,'Value',i); 
            end
              
end
    
% Hint: get(hObject,'Value') returns toggle state of togglebutton2
%}

% --- Executes on button press in pushbutton7.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
N(:,:,:)=handles.N(:,:,:);
R=handles.R;
D=handles.D;
dname=handles.dname;
% currentSlice=handles.currentSlice;
% s=handles.s;

b=imread('playbutton.png');
n=get(hObject,'Value');
set(handles.slider1,'Value',1);

        set(hObject,'CData',b);
            for i=1:length(D);
                R=dicomread(fullfile(dname,D(i).name));
                N(:,:,i)=R;
                axes(handles.axes2);
                set(gca,'YTick',[]);
                imagesc(R);pause(0.09);        
                set(handles.text33, 'String', D(i).name);
                set(handles.text32, 'String', i);
                set(handles.slider1,'Value',i); 
            end
    


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% a=imread('pausebutton.png'); 
% set(hObject,'CData',a);
%             axes(handles.axes2);
%              pause(inf);

% --- Executes on button press in pushbutton9.


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
n=get(hObject,'Value');
if n==1
    set(handles.togglebutton3,'String','Play');
    uiwait();
    
else   
    set(handles.togglebutton3,'String','Pause');
    uiresume();
end
% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_clicked=get(hObject,'Value');
 val1 = str2num(get([handles.edit1], 'String'));
        val2 = str2num(get([handles.edit2], 'String'));
        val3 = str2num(get([handles.edit3], 'String'));
        val4 = str2num(get([handles.edit4], 'String'));
        val5 = str2num(get([handles.edit5], 'String'));
        val6 = str2num(get([handles.edit6], 'String'));
        val7 = str2num(get([handles.edit7], 'String'));
        val9 = str2num(get([handles.edit9], 'String'));
        
        %%Map Ktrans 0-5 to 0-1
Ktrans_min=0;
Ktrans_max=5;
Pump_max=4499;

%Pump 1
Ktrans_UI1=val1;
Ktrans_map1=(Ktrans_UI1-Ktrans_min)/(Ktrans_max-Ktrans_min); %0-5 will be mapped to 0-1;

Pump_flowrate1=((Ktrans_map1)*(Pump_max-1))+1;
Flow_rate1=int16(Pump_flowrate1);
set(handles.text36,'String',Flow_rate1);

%Pump 2
Ktrans_UI2=val3;

Ktrans_map2=(Ktrans_UI2-Ktrans_min)/(Ktrans_max-Ktrans_min); %0-5 will be mapped to 0-1;

Pump_flowrate2=((Ktrans_map2)*(Pump_max-1))+1;
Flow_rate2=int16(Pump_flowrate2);
set(handles.text37,'String',Flow_rate2);

   

val8=(val7*60);
   handles.val1=val1;
   guidata(hObject,handles);
   
if(button_clicked==1)
    try
       
%% Ktrans,Kep Validation
%%
if ((isempty(val1)||(val1)>5))
    set(handles.text13,'String','Error : Please enter the Valid Ktrans data (Range : 0-5)');
    set(handles.text22,'String','*');
    axes(handles.axes1);
    cla reset; 
    else if((isempty(val2)||(val2)>5000))
        set(handles.text13,'String','Error : Please enter the Valid Kep data (Range : 0-5000) ');
            set(handles.text24,'String','*');
        axes(handles.axes1);
            cla reset;   
        else if ((isempty(val3)||(val3)>5))
                set(handles.text13,'String','Error : Please enter the Valid Ktrans data (Range : 0-10)');
                set(handles.text21,'String','*');
                axes(handles.axes1);
                cla reset; 
                else if((isempty(val4)||(val4)>5000))
                    set(handles.text13,'String','Error : Please enter the Valid Kep data (Range : 0-5000) ');
                    set(handles.text23,'String','*');    
                    axes(handles.axes1);
                        cla reset;  
                         else if ((isempty(val5)||(val5)>5))
                              set(handles.text13,'String','Error : Please enter the Valid Ktrans data (Range : 0-10)');
                              set(handles.text19,'String','*');
                              axes(handles.axes1);
                              cla reset; 
                                    else if((isempty(val6)||(val6)>5000))
                                            set(handles.text13,'String','Error : Please enter the Valid Kep data (Range : 0-5000) ');
                                            set(handles.text20,'String','*');
                                            axes(handles.axes1);
                                            cla reset;  
                                                else if(isempty(val7))
                                                        set(handles.text13,'String','Error : Please enter the Valid Tacq data ');
                                                        set(handles.text25,'String','*');    
                                                        axes(handles.axes1);
                                                        cla reset; 
                                                        else if(isempty(val9))
                                                                set(handles.text13,'String','Error : Please enter the Valid Time Points data ');
                                                                set(handles.text27,'String','*');    
                                                                axes(handles.axes1);
                                                                cla reset; 
                                                            else
                                                              set(handles.text13,'String','');
                                                              axes(handles.axes1);
                                                              cla reset; 
 
                                                                                                     
                                                                                                     %time_var = val7/val8;
                                                                                                    %%
%                                                                                                             Ca=handles.Ca;
%                                                                                                             t=1:time_var:time_var*val8;
                                                                                                            
                                                                                                            A1=0.809;
                                                                                                            A2=0.330;
                                                                                                            T1=0.17046;
                                                                                                            T2=0.365;
                                                                                                            sig1=0.0563;
                                                                                                            sig2=0.132;
                                                                                                            Time_var=(val9/60);
                                                                                                            
                                                                                                            valn=(val8/val9);
%                                                                                                             t_1=(val7/60);
                                                                                                            t=1:Time_var:Time_var*valn;
                                                                                                            %t_2=(t_1*valn);
                                                                                                            handles.Time_var=Time_var;
                                                                                                            guidata(hObject,handles);
                                                                                                            set(handles.text18,'String',Time_var);
 
 
                                                                                                            %%
                                                                                                            k1=(A1/(sig1*sqrt(2*pi)))*exp(-(t-T1).^2/(2*(sig1.^2)));
                                                                                                            % plot(t,k1);
                                                                                                            k11=(A2/(sig2*sqrt(2*pi)))*exp(-(t-T2).^2/(2*(sig2.^2)));
                                                                                                            %Figure,plot(t,k11);
 
                                                                                                            %%
                                                                                                            a=1.050;
                                                                                                            b=0.1685;
                                                                                                            k2 = a.*exp(-b*t);
                                                                                                            %plot(t,k2);
 
 
                                                                                                            %%
                                                                                                            s=38.078;
                                                                                                            tau=0.483;
                                                                                                            k3 = (1 + exp(-s*(t-tau)));
                                                                                                            %plot(t,k3);
 
                                                                                                            %%
                                                                                                            k = k1+ k2./k3;
                                                                                                            %plot(t,k,'ro-');
 
                                                                                                            K=k11+ k2./k3;
                                                                                                            %plot(t,K,'b*--');
 
                                                                                                            Ca=k+K;
 
                                                                                                            Ca=Ca ./ max(Ca(:));
                                                                                                            % plot(t,Ca,'r--*');
                                                                                                            % 
                                                                                                            % xlabel('time(min)');
                                                                                                            % ylabel('Ca(mmol)')
%%                     %%
                                                                                    %forward simulating concentration time curves
 
                                                                                                    L=cconv(val1*exp(-t*val2),Ca,length(Ca));         
                                                                                                    M=cconv(val3*exp(-t*val4),Ca,length(Ca));         
                                                                                                    N=cconv(val5*exp(-t*val6),Ca,length(Ca));   
                                                                                                     axes(handles.axes1);
                                                                                                     %figure, plot(Ca);
                                                                                                     plot(t,L,'-r',t,M,'-g',t,N,'-b'); 
                                                                                                     legend('Inlet 1','Inlet 2','Inlet 3')
%                                                                                                      hold all;
%                                                                                                      plot(t_1,M); 
%                                                                                                      hold all;
%                                                                                                      plot(t_1,N); 
                                                                                                     xlabel('Time(min)');
                                                                                                     ylabel('Ct(mM)');
                                                                                                     title('Concentration Time Curves');
                                                                                                     
                                                                                                     %% Phantom setup parameter
                                                                                                    %{
                                                                                                      Flow_rate1=round(val1*899.8);
                                                                                                     set(handles.text36,'String',Flow_rate1);
                                                                                                      Flow_rate2=round(val3*899.8);
                                                                                                     set(handles.text37,'String',Flow_rate2);
                                                                                                      Flow_rate3=round(val5*899.8);
                                                                                                     set(handles.text38,'String',Flow_rate3);
                                                                                                    %}
                                                                                                    
                                                                                                   
                                                                                                    

                                                                                                %%Peristaltic Pump Interface
                                                                                                fileID = fopen('C:\Users\HP\AppData\Roaming\Default Company Name\Setup for pc interface\Pump.txt','w');
                                                                                                %Pump1
                                                                                                
                                                                                                Fwd_min1=val7;Fwd_sec1=0;Fwd_msec1=0;Rvs_min1=0;Rvs_sec1=0;Rvs_msec1=1;Cycle1=1;

                                                                                                %Pump2
                                                                                                
                                                                                                Fwd_min2=val7;Fwd_sec2=0;Fwd_msec2=0;Rvs_min2=0;Rvs_sec2=0;Rvs_msec2=1;Cycle2=1;
                                                                                                Reset=3;On_off=1;

                                                                                                fprintf(fileID,'%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n',Flow_rate1,Fwd_min1,Fwd_sec1,Fwd_msec1,Rvs_min1,Rvs_sec1,Rvs_msec1,Cycle1);
                                                                                                fprintf(fileID,'%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d',Flow_rate2,Fwd_min2,Fwd_sec2,Fwd_msec2,Rvs_min2,Rvs_sec2,Rvs_msec2,Cycle2);

                                                                                                fprintf(fileID,'\r\n\r\n%d\r\n%d',Reset,On_off);
                                                                                                
                                                                                                fclose(fileID);
                                                                                                set(handles.text39,'String','O');
 
                                                            end
                                                    end
                                        end
                             end
                    end
            end
        end
end

catch
    A=throw(Exception);
end

else
                                                                                                fileID = fopen('C:\Users\HP\AppData\Roaming\Default Company Name\Setup for pc interface\Pump.txt','w');
                                                                                                %Pump1
                                                                                                
                                                                                                Fwd_min1=val7;Fwd_sec1=0;Fwd_msec1=0;Rvs_min1=0;Rvs_sec1=0;Rvs_msec1=1;Cycle1=1;

                                                                                                %Pump2
                                                                                                
                                                                                                Fwd_min2=val7;Fwd_sec2=0;Fwd_msec2=0;Rvs_min2=0;Rvs_sec2=0;Rvs_msec2=1;Cycle2=1;
                                                                                                Reset=3;On_off=0;

                                                                                                fprintf(fileID,'%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n',Flow_rate1,Fwd_min1,Fwd_sec1,Fwd_msec1,Rvs_min1,Rvs_sec1,Rvs_msec1,Cycle1);
                                                                                                fprintf(fileID,'%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d\r\n%d',Flow_rate2,Fwd_min2,Fwd_sec2,Fwd_msec2,Rvs_min2,Rvs_sec2,Rvs_msec2,Cycle2);

                                                                                                fprintf(fileID,'\r\n\r\n%d\r\n%d',Reset,On_off);

                                                                                                fclose(fileID);
                                                                                                set(handles.text39,'String',' ');
end
% Hint: get(hObject,'Value') returns toggle state of togglebutton4
