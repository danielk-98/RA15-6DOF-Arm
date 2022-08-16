function varargout = fread(obj, varargin)
%FREAD Read binary data from instrument.
%
%   A=FREAD(OBJ) reads values from the instrument connected to
%   interface object, OBJ, and returns to A. The maximum number
%   of values is given by the InputBufferSize property.
%
%   A=FREAD(OBJ,SIZE) reads at most the specified number of values,
%   SIZE, from the instrument connected to interface object, OBJ,
%   and returns to A.
%
%   For serial port, VISA-serial and TCPIP objects, FREAD blocks
%   until one of the following occurs:
%       1. InputBufferSize values have been received
%       2. SIZE values have been received
%       3. A timeout occurs as specified by the Timeout property
%
%   For GPIB, VISA-GPIB, VISA-VXI, VISA-GPIB-VXI, VISA-TCPIP, VISA-USB
%   and VISA-RSIB objects, FREAD blocks until one of the following occurs:
%       1. InputBufferSize values have been received
%       2. SIZE values have been received
%       3. EOI line has been asserted
%       4. The terminator is received as specified by the EOSCharCode
%          property (if defined). This option is not available for
%          VISA-RSIB objects.
%       5. A timeout occurs as specified by the Timeout property.
%
%   For UDP objects, FREAD blocks until one of the following occurs:
%       1. InputBufferSize values have been received
%       2. SIZE values have been received (if DatagramTerminateMode is off)
%       3. A datagram has been received (if DatagramTerminateMode is on)
%       4. A timeout occurs as specified by the Timeout property
%
%   The interface object must be connected to the instrument with
%   the FOPEN function before any data can be read from the instrument
%   otherwise an error is returned. A connected interface object
%   has a Status property value of open.
%
%   For GPIB, VISA-GPIB, VISA-VXI, VISA-GPIB-VXI, VISA-TCPIP and VISA-USB
%   objects, the terminator is defined by setting OBJ's EOSMode property to
%   read and setting OBJ's EOSCharCode property to the ASCII code for the
%   character received. For example, if the EOSMode property is set
%   to read and the EOSCharCode property is set to LF, then one of
%   the ways that the read terminates is when the linefeed character
%   is received. A terminator cannot be defined for VISA-RSIB objects.
%
%   Available options for SIZE include:
%
%      N      read at most N values into a column vector.
%      [M,N]  read at most M * N values filling an M-by-N matrix,
%             in column order.
%
%   SIZE cannot be set to INF. If SIZE is greater than the OBJ's
%   InputBufferSize property value an error will be returned. Note
%   that SIZE is specified in values while the InputBufferSize is
%   specified in bytes.
%
%   A=FREAD(OBJ,SIZE,'PRECISION') reads binary data with the specified
%   precision, PRECISION. The precision argument controls the number
%   of bits read for each value and the interpretation of those bits
%   as character, integer or floating point values. The supported
%   PRECISION strings are defined below. By default the 'uchar'
%   PRECISION is used. By default, numeric values are returned in
%   double precision arrays.
%
%      MATLAB           Description
%      'uchar'          unsigned character,  8 bits.
%      'schar'          signed character,    8 bits.
%      'int8'           integer,             8 bits.
%      'int16'          integer,             16 bits.
%      'int32'          integer,             32 bits.
%      'uint8'          unsigned integer,    8 bits.
%      'uint16'         unsigned integer,    16 bits.
%      'uint32'         unsigned integer,    32 bits.
%      'single'         floating point,      32 bits.
%      'float32'        floating point,      32 bits.
%      'double'         floating point,      64 bits.
%      'float64'        floating point,      64 bits.
%      'char'           character,           8 bits (signed or unsigned).
%      'short'          integer,             16 bits.
%      'int'            integer,             32 bits.
%      'long'           integer,             32 or 64 bits.
%      'ushort'         unsigned integer,    16 bits.
%      'uint'           unsigned integer,    32 bits.
%      'ulong'          unsigned integer,    32 bits or 64 bits.
%      'float'          floating point,      32 bits.
%
%   [A,COUNT]=FREAD(OBJ,...) returns the number of values read to COUNT.
%
%   [A,COUNT,MSG]=FREAD(OBJ,...) returns a message, MSG, if FREAD
%   did not complete successfully. If MSG is not specified a warning
%   is displayed to the command line.
%
%   [A,COUNT,MSG,DATAGRAMADDRESS]=FREAD(OBJ,...) returns the datagram
%   address to DATAGRAMADDRESS, if OBJ is a UDP object. If more than
%   one datagram is read, DATAGRAMADDRESS is ''.
%
%   [A,COUNT,MSG,DATAGRAMADDRESS,DATAGRAMPORT]=FREAD(OBJ,...) returns
%   the datagram port to DATAGRAMPORT, if OBJ is a UDP object. If more
%   than one datagram is read, DATAGRAMPORT is [].
%
%   The byte order of the instrument can be specified with OBJ's
%   ByteOrder property.
%
%   OBJ's ValuesReceived property will be updated by the number of
%   values read from the instrument.
%
%   If OBJ's RecordStatus property is configured to on with the RECORD
%   function, the data received will be recorded in the file specified
%   by OBJ's RecordName property value.
%
%   Example:
%       g = gpib('iotech', 1, 2);
%       fopen(g);
%       fprintf(g, 'Curve?');
%       data = fread(g, 512);
%       fclose(g);
%
%   See also ICINTERFACE/FOPEN, ICINTERFACE/FCLOSE, ICINTERFACE/FWRITE,
%   ICINTERFACE/FSCANF, ICINTERFACE/RECORD, INSTRUMENT/PROPINFO, INSTRHELP.

%   Copyright 1999-2017 The MathWorks, Inc.

% Error checking.
if nargout > 3
    error(message('instrument:fread:invalidSyntaxRet'));
end

if ~isa(obj, 'icinterface')
    error(message('instrument:fread:invalidOBJInterface'));
end

if length(obj)>1
    error(message('instrument:fread:invalidOBJDim'));
end

% convert to char in order to accept string datatype
varargin = instrument.internal.stringConversionHelpers.str2char(varargin);

% Parse the input.
switch nargin
    case 1
        size = get(obj, 'InputBufferSize');
        precision = 'uchar';
    case 2
        size = varargin{1};
        precision = 'uchar';
    case 3
        [size, precision] = deal(varargin{:});
    otherwise
        error(message('instrument:fread:invalidSyntaxArgv'));
end

% Error checking.
if ~isa(precision, 'char')
    error(message('instrument:fread:invalidPRECISIONstring'));
elseif ~isa(size, 'double')
    error(message('instrument:fread:invalidSIZEdouble'));
elseif size<=0
    error(message('instrument:fread:invalidSIZEpos'));
elseif any(isinf(size))
    error(message('instrument:fread:invalidSIZEinf'));
elseif any(isnan(size))
    error(message('instrument:fread:invalidSIZEnan'));
end

% Define the type of data to be read.
switch precision
    case {'uchar', 'char'}
        type = 5;
        signed = 0;
    case 'schar'
        type = 5;
        signed = 1;
    case 'int8'
        type = 0;
        signed = 1;
    case {'int16', 'short'}
        type = 1;
        signed = 1;
    case {'int32', 'int', 'long'}
        type = 2;
        signed = 1;
    case 'uint8'
        type = 0;
        signed = 0;
    case {'uint16', 'ushort'}
        type = 1;
        signed = 0;
    case {'uint32', 'uint', 'ulong'}
        type = 2;
        signed = 0;
    case {'single', 'float32', 'float'}
        type = 3;
        signed = 1;
    case {'double' ,'float64'}
        type = 4;
        signed = 1;
    otherwise
        error(message('instrument:fread:invalidPRECISION'));
end

% Floor the size.
% Note: The call to floor must be done after the error checking
% since floor on a string converts the string to its ascii value.
size = floor(size);

% Determine the total number of elements to read.
switch length(size)
    case 1
        totalSize = size;
        size = [size 1];
    case 2
        totalSize = size(1)*size(2);
    otherwise
        error(message('instrument:fread:invalidSIZE'));
end

% The Terminating character needs to be disabled for VISA Generic Object
% binary reads otherwise a binary read will end when a LF or CR was
% encountered. This may have been a firmware bug.
if strcmpi(obj.jobject.Type,'visa-generic')
    OldEOSMode = obj.jobject.EOSMode;
    obj.jobject.EOSMode = 'none';
end

% Call the fread java method.
try
    % Out contains the data and the number of data ready.
    out = fread(igetfield(obj, 'jobject'), totalSize, type, signed);
catch aException
    % Restore the VISA Generic object's terminating character.
    if strcmpi(obj.jobject.Type,'visa-generic')
        obj.jobject.EOSMode = OldEOSMode;
    end
    newExc = MException('instrument:fread:opfailed', aException.message);
    throw(newExc);
end

% Restore the VISA Generic object's terminating character.
if strcmpi(obj.jobject.Type,'visa-generic')
    obj.jobject.EOSMode = OldEOSMode;
end

% Parse the result from the java fread method.
data = out(1);
numRead = out(2);
warningstr = out(3);

if numRead ~= totalSize
    data = localFormatData(double(data(1:numRead)), precision);

    % Store the warning state.
    warnState = warning('backtrace', 'off');
    if ~isempty(warningstr)
        if numRead == 0
            warningstr = instrument.internal.warningMessagesHelpers.getReadWarning(warningstr, obj.class, obj.DocIDNoData, 'nodata');
        else
            warningstr = instrument.internal.warningMessagesHelpers.getReadWarning(warningstr, obj.class, obj.DocIDSomeData, 'somedata');
        end
        if nargout < 3
            warning('instrument:fread:unsuccessfulRead', warningstr);
        end
    end

    varargout = {data, numRead, warningstr};
    % Restore warning state.
    warning(warnState);
    return;
end

outputMessage = warningstr;
% If the numread==totalSize specified by the user.
try
    data = localFormatData(data, precision);
    % Data was successfully read and formatted.
    outputData = reshape(data, size(1), size(2));

catch ex
    % An error occurred while reshaping. Return the data as an array.
    outputData = double(data);
    outputMessage = ex.message;
end

% Warn if the MSG output variable is not specified.
if nargout ~= 3 && ~isempty(outputMessage)
    % Store the warning state.
    warnState = warning('backtrace', 'off');
    warning(message('instrument:fread:unsuccessfulRead', outputMessage));

    % Restore the warning state.
    warning(warnState);
end
varargout = {outputData, numRead, outputMessage};

% --------------------------------------------------------------
function dataout = localFormatData(datain, precision)

try
    switch precision
        case {'uint8', 'uchar', 'char'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*256;
        case {'uint16', 'ushort'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*65536;
        case {'uint32', 'uint', 'ulong'}
            dataout = double(datain);
            dataout = dataout + (dataout<0).*(2^32);
        case {'int8', 'schar'}
            dataout = double(datain);
            dataout = dataout - (dataout>127)*256;
        otherwise
            dataout = double(datain);
    end
catch
    dataout = double(datain);
end

