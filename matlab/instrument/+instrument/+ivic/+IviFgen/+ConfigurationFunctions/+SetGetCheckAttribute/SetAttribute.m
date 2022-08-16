classdef SetAttribute < instrument.ivic.IviGroupBase
    %SETATTRIBUTE This class contains functions that set an
    %attribute to a new value.  There are typesafe functions for
    %each attribute data type.
    
    % Copyright 2010 The MathWorks, Inc.
    
    %% Public Methods
    methods
        function SetAttributeViInt32(obj,ChannelName,AttributeID,AttributeValue)
            %SETATTRIBUTEVIINT32 This function sets the value of a
            %ViInt32 attribute.  This is a low-level function that you
            %can use to set the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid or is different than the
            %value you specify.   This instrument driver contains
            %high-level functions that set most of the instrument
            %attributes.  It is best to use the high-level driver
            %functions as much as possible. They handle order
            %dependencies and multithread locking for you. In addition,
            %they perform status checking only after setting all of the
            %attributes. In contrast, when you set multiple attributes
            %using the SetAttribute functions, the functions check the
            %instrument status after each call.  Also, when state
            %caching is enabled, the high-level functions that configure
            %multiple attributes perform instrument I/O only for the
            %attributes whose value you change. Thus, you can safely
            %call the high-level functions without the penalty of
            %redundant instrument I/O.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarInt32Arg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_SetAttributeViInt32', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetAttributeViReal64(obj,ChannelName,AttributeID,AttributeValue)
            %SETATTRIBUTEVIREAL64 This function sets the value of a
            %ViReal64 attribute.  This is a low-level function that you
            %can use to set the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid or is different than the
            %value you specify.   This instrument driver contains
            %high-level functions that set most of the instrument
            %attributes. It is best to use the high-level driver
            %functions as much as possible. They handle order
            %dependencies and multithread locking for you. In addition,
            %they perform status checking only after setting all of the
            %attributes. In contrast, when you set multiple attributes
            %using the SetAttribute functions, the functions check the
            %instrument status after each call.  Also, when state
            %caching is enabled, the high-level functions that configure
            %multiple attributes perform instrument I/O only for the
            %attributes whose value you change. Thus, you can safely
            %call the high-level functions without the penalty of
            %redundant instrument I/O.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarDoubleArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_SetAttributeViReal64', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetAttributeViString(obj,ChannelName,AttributeID,AttributeValue)
            %SETATTRIBUTEVISTRING This function sets the value of a
            %ViString attribute.  This is a low-level function that you
            %can use to set the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid or is different than the
            %value you specify.   This instrument driver contains
            %high-level functions that set most of the instrument
            %attributes. It is best to use the high-level driver
            %functions as much as possible. They handle order
            %dependencies and multithread locking for you. In addition,
            %they perform status checking only after setting all of the
            %attributes. In contrast, when you set multiple attributes
            %using the SetAttribute functions, the functions check the
            %instrument status after each call.  Also, when state
            %caching is enabled, the high-level functions that configure
            %multiple attributes perform instrument I/O only for the
            %attributes whose value you change. Thus, you can safely
            %call the high-level functions without the penalty of
            %redundant instrument I/O.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarStringArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                AttributeValue = [double(AttributeValue) 0];
                
                status = calllib( libname,'IviFgen_SetAttributeViString', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetAttributeViBoolean(obj,ChannelName,AttributeID,AttributeValue)
            %SETATTRIBUTEVIBOOLEAN This function sets the value of a
            %ViBoolean attribute.  This is a low-level function that you
            %can use to set the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid or is different than the
            %value you specify.   This instrument driver contains
            %high-level functions that set most of the instrument
            %attributes.  It is best to use the high-level driver
            %functions as much as possible. They handle order
            %dependencies and multithread locking for you. In addition,
            %they perform status checking only after setting all of the
            %attributes. In contrast, when you set multiple attributes
            %using the SetAttribute functions, the functions check the
            %instrument status after each call.  Also, when state
            %caching is enabled, the high-level functions that configure
            %multiple attributes perform instrument I/O only for the
            %attributes whose value you change. Thus, you can safely
            %call the high-level functions without the penalty of
            %redundant instrument I/O.
            
            narginchk(4,4)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            AttributeValue = obj.checkScalarBoolArg(AttributeValue);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_SetAttributeViBoolean', session, ChannelName, AttributeID, AttributeValue);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
        
        function SetAttributeViSession(obj,ChannelName,AttributeID)
            %SETATTRIBUTEVISESSION This function sets the value of a
            %session attribute.  This is a low-level function that you
            %can use to set the values of inherent IVI attributes, class
            %defined attributes, and instrument-specific attributes. If
            %the attribute represents an instrument state, this function
            %performs instrument I/O in the following cases:  - State
            %caching is disabled for the entire session or for the
            %particular attribute.  - State caching is enabled and the
            %currently cached value is invalid or is different than the
            %value you specify.   This instrument driver contains
            %high-level functions that set most of the instrument
            %attributes. It is best to use the high-level driver
            %functions as much as possible. They handle order
            %dependencies and multithread locking for you. In addition,
            %they perform status checking only after setting all of the
            %attributes. In contrast, when you set multiple attributes
            %using the SetAttribute functions, the functions check the
            %instrument status after each call.  Also, when state
            %caching is enabled, the high-level functions that configure
            %multiple attributes perform instrument I/O only for the
            %attributes whose value you change. Thus, you can safely
            %call the high-level functions without the penalty of
            %redundant instrument I/O.
            
            narginchk(3,3)
            ChannelName = obj.checkScalarStringArg(ChannelName);
            AttributeID = obj.checkScalarInt64Arg(AttributeID);
            try
                [libname, session ] = obj.getLibraryAndSession();
                ChannelName = [double(ChannelName) 0];
                
                status = calllib( libname,'IviFgen_SetAttributeViSession', session, ChannelName, AttributeID, session);
                
                obj.checkError(status);
            catch e
                throwAsCaller(e);
            end
        end
    end
end
