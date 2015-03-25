function varargout = billsystem(varargin)
% BILLSYSTEM M-file for billsystem.fig
%      BILLSYSTEM, by itself, creates a new BILLSYSTEM or raises the existing
%      singleton*.
%
%      H = BILLSYSTEM returns the handle to a new BILLSYSTEM or the handle to
%      the existing singleton*.
%
%      BILLSYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BILLSYSTEM.M with the given input arguments.
%
%      BILLSYSTEM('Property','Value',...) creates a new BILLSYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before billsystem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to billsystem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help billsystem

% Last Modified by GUIDE v2.5 25-Mar-2015 19:58:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @billsystem_OpeningFcn, ...
                   'gui_OutputFcn',  @billsystem_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT


% --- Executes just before billsystem is made visible.
function billsystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to billsystem (see VARARGIN)

% Choose default command line output for billsystem
handles.output = hObject;
global TOTAL_BILL;
TOTAL_BILL = 0;
% Update handles structure
guidata(hObject, handles);
end
% UIWAIT makes billsystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = billsystem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end



function prodEB_Callback(hObject, eventdata, handles)
% hObject    handle to prodEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prodEB as text
%        str2double(get(hObject,'String')) returns contents of prodEB as a double
end

% --- Executes during object creation, after setting all properties.
function prodEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prodEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


function qEB_Callback(hObject, eventdata, handles)
% hObject    handle to qEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of qEB as text
%        str2double(get(hObject,'String')) returns contents of qEB as a double
end

% --- Executes during object creation, after setting all properties.
function qEB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to qEB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in addprodPB.
function addprodPB_Callback(hObject, eventdata, handles)
% hObject    handle to addprodPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    prod = gettext('prodEB');
    if(isempty(prod)) 
        setbtmtext('Enter a product name');
        return;
    end
    quan = int32(str2double(gettext('qEB')));
    if(quan == 0)
        quan = 1;
    end
    productcost = addProduct(prod);
    if(productcost == 0) 
        setbtmtext('Product doesn''t exist');
        return;
    end
    total = productcost * quan;
    global TOTAL_BILL;
    TOTAL_BILL = TOTAL_BILL + total;
    setTBtext('totalrs',int2str(TOTAL_BILL));
    data = get(gethand('table'),'Data');

    data = [ data; cellstr(prod) {quan} {productcost} total; ];
    
    set(gethand('table'),'Data',data);
    
end

% --- Executes on button press in finalbillPB.
function finalbillPB_Callback(hObject, eventdata, handles)
% hObject    handle to finalbillPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global menulist;
    menulist = get(gethand('table'),'Data');
    receipt
end

% --- Executes on button press in remPB.
function remPB_Callback(hObject, eventdata, handles)
% hObject    handle to remPB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    data = get(gethand('table'),'Data');
    global rowSelected;
    sizedata = size(data);
    if(sizedata(1,:) == 0) 
        return;
    end
    subt = cell2mat(data(rowSelected,4));
    global TOTAL_BILL;
    TOTAL_BILL = TOTAL_BILL - subt;
    setTBtext('totalrs',TOTAL_BILL);
    data(rowSelected,:) = [];
    set(gethand('table'),'Data',data);
end



function setTBtext(objtag, text) 
    set(findobj('Tag',objtag),'String',text);
end

function setbtmtext(text) 
    set(findobj('Tag','btmTB'),'String',text);
end

function returnText = getTBtext(objtag) 
    returnText = get(findobj('Tag',objtag),'String');
end

function returnText = gettext(objtag) 
    returnText = get(findobj('Tag',objtag),'String');
end

function hand = gethand(tag)
    hand = findobj('Tag',tag);
end


% --- Executes during object creation, after setting all properties.
function table_CreateFcn(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
    data = [];
    set(gethand('table'),'Data',data);
end


% --- Executes when selected cell(s) is changed in table.
function table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
    global rowSelected;
    row = eventdata.Indices;
    if(size(row) == [0,2])
        return;
    end
    rowSelected = row(1,1);
end


% --- Executes on button press in addmenu.
function addmenu_Callback(hObject, eventdata, handles)
% hObject    handle to addmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    prod = gettext('prodEB');
    if(isempty(prod)) 
        setbtmtext('Enter a product name');
        return;
    end
    quan = int32(str2double(gettext('qEB')));
    if(quan == 0)
        setbtmtext('Enter product price');
    end
    fdir = fullfile(pwd,'menu',char(prod));
    dlmwrite(fdir,quan,'');
end