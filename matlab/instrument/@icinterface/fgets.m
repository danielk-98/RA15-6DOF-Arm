function varargout = fgets(obj)
%FGETS Read one line of text from instrument, keep terminator.
%
%   TLINE=FGETS(OBJ) reads one line of text from the instrument
%   connected to interface object, OBJ and returns to TLINE. The
%   returned data does include the terminator with the text line.
%   To exclude the terminator, use FGETL.
%
%   For serial port, VISA-serial and TCPIP objects, FGETS blocks
%   until one of the following occurs:
%       1. The terminator is received as specified by the Terminator
%          property
%       2. A timeout occurs as specified by the Timeout property
%       3. The input buffer is filled
%
%   For GPIB, VISA-GPIB, VISA-VXI, VISA-GPIB-VXI, VISA-TCPIP, VISA-USB
%   and VISA-RSIB objects, FGETS blocks until one of the following occurs:
%       1. The EOI line is asserted
%       2. The terminator is received as specified by the EOSCharCode
%          property (if defined). This option is not available for
%          VISA-RSIB objects.
%       3. A timeout occurs as specified by the Timeout property
%       4. The input buffer is filled
%
%   For UDP objects, FGETS blocks until one of the following occurs:
%       1. The terminator is received as specified by the terminator
%          property (if DatagramTerminateMode is off).
%       2. A datagram has been received (if DatagramTerminateMode is on).
%       3. A timeout occurs as specified by the Timeout property.
%
%   The interface object, OBJ, must be connected to the instrument with
%   the FOPEN function before any data can be read from the instrument
%   otherwise an error is returned. A connected interface object has
%   a Status property value of open.
%
%   For GPIB, VISA-GPIB, VISA-VXI, VISA-GPIB-VXI, VISA-TCPIP and VISA-USB
%   objects, the terminator is defined by setting OBJ's EOSMode property to
%   read or read&write and setting OBJ's EOSCharCode property to the ASCII
%   code for the character received. For example, if the EOSMode property
%   is set to read and the EOSCharCode property is set to LF, then one of
%   the ways that the read terminates is when the linefeed character
%   is received. A terminator cannot be defined for VISA-RSIB objects.
%
%   [TLINE,COUNT]=FGETS(OBJ) returns the number of values read to COUNT.
%   COUNT includes the terminator.
%
%   [TLINE,COUNT,MSG]=FGETS(OBJ) returns a message, MSG, if FGETS did
%   not complete successfully. If MSG is not specified a warning is
%   displayed to the command line.
%
%   [TLINE,COUNT,MSG,DATAGRAMADDRESS]=FGETS(OBJ) returns the datagram
%   address to DATAGRAMADDRESS, if OBJ is a UDP object. If more than %   one datagram is read, DATAGRAMADDRESS is ''.
%
%   [TLINE,COUNT,MSG,DATAGRAMADDRESS,DATAGRAMPORT]=FGETS(OBJ) returns
%   the datagram port to DATAGRAMPORT, if OBJ is a UDP object. If more
%   than one datagram is read, DATAGRAMPORT is [].
%
%   OBJ's ValuesReceived property will be updated by the number of values
%   read from the instrument including the terminator.
%
%   If OBJ's RecordStatus property is configured to on with the RECORD
%   function, the data received, TLINE, will be recorded in the file
%   specified by OBJ's RecordName property value.
%
%   Examples:
%       g = visa('agilent', 'GPIB0::2::0::INSTR');
%       fopen(g)
%       fprintf(g, '*IDN?');
%       idn = fgets(g);
%       fclose(g);
%
%   See also ICINTERFACE/FGETL, ICINTERFACE/FOPEN, ICINTERFACE/QUERY,
%   ICINTERFACE/RECORD, INSTRUMENT/PROPINFO, INSTRHELP.

%   Copyright 1999-2017 The MathWorks, Inc.

% Error checking.
if length(obj) > 1
    error(message('instrument:fgets:invalidOBJ'));
end

if nargout > 3
    error(message('instrument:fgets:invalidSyntax'));
end

% Call the jave fgets method.
try
    out = fgets(igetfield(obj, 'jobject'));
catch aException
    newExc = MException('instrument:fgets:opfailed', aException.message);
    throw(newExc);
end

% Extract data from fgets java code
dataValues = out(1);
dataCount = out(2);
warningstr = out(3);

% Warn if the MSG output variable is not specified.
if ~isempty(warningstr)
    % Store the warning state.
    warnState = warning('backtrace', 'off');
    if isempty(dataValues)
        warningstr = instrument.internal.warningMessagesHelpers.getReadWarning(warningstr, obj.class, obj.DocIDNoData, 'nodata');
    else
        warningstr = instrument.internal.warningMessagesHelpers.getReadWarning(warningstr, obj.class, obj.DocIDSomeData, 'somedata');
    end

    if nargout < 3
        warning('instrument:fgets:unsuccessfulRead', warningstr);
    end

    % Restore the warning state.
    warning(warnState);
end

% Construct the output.
varargout = {dataValues, dataCount, warningstr};
end