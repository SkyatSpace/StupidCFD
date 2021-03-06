% ## Copyright (C) 2013 homu
% ## 
% ## This program is free software; you can redistribute it and/or modify
% ## it under the terms of the GNU General Public License as published by
% ## the Free Software Foundation; either version 3 of the License, or
% ## (at your option) any later version.
% ## 
% ## This program is distributed in the hope that it will be useful,
% ## but WITHOUT ANY WARRANTY; without even the implied warranty of
% ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% ## GNU General Public License for more details.
% ## 
% ## You should have received a copy of the GNU General Public License
% ## along with Octave; see the file COPYING.  If not, see
% ## <http://www.gnu.org/licenses/>.

% ## EBGlobals

% ## Author: homu <homu@HOMU-PC>
% ## Created: 2013-08-07

global rho nu 
global UIn
global POut

global nu_s
global nucell nunode
global uind vind

% boundary conditions in order [x-low, x-high, y-low,y-high]
global BCPhysType
global BCUMac BCVMac
global BCPres

% Couette flow
global R0 Omega0
global R1 Omega1


global ebls ebls_umac ebls_vmac
global ebvof ebvof_macx ebvof_macy
global eb_umac eb_vmac
global eb_usurf eb_vsurf
global eb_flag eb_uflag eb_vflag


