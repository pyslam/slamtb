function [u,s,U_i,U_k,U_d] = pinHoleIdp(i,k,d)

% PINHOLEIDP Pin-hole camera model for Inverse depth points, with radial distortion.
%   U = PINHOLEIDP(I) gives the projected pixel U of an Inverse Depth point
%   I in a canonical pin-hole camera, that is, with calibration parameters
%     u0 = 0
%     v0 = 0
%     au = 1
%     av = 1
%   It uses reference frames {RDF,RD} (right-down-front for the 3D world
%   points and right-down for the pixel), according to this scheme:
%
%          / z
%         /
%        /
%       +------- x      +------- u
%       |               |
%       |    3D         |   image
%       |               |
%       | y             | v
%
%   U = PINHOLEIDP(I,K) allows the introduction of the camera's calibration
%   parameters:
%     K = [u0 v0 au av]'
%
%   U = PINHOLEIDP(I,K,D) allows the introduction of the camera's radial
%   distortion parameters:
%     D = [K2 K4 K6 ...]'
%   so that the new pixel is distorted following the distortion equation:
%     U_D = U * (1 + K2*R^2 + K4*R^4 + ...)
%   with R^2 = sum(U.^2), being U the projected point in the image plane
%   for a camera with unit focal length.
%
%   If I is a IDPs matrix, PINHOLEIDP(I,...) returns a pixel matrix U, with
%   these matrices defined as
%     U = [U1 ... Un];   Ui = [ui;vi]
%     I = [I1 ... In];   Ii = [Xi;Yi;Zi,pi,yi,ri]
%   where pi, yi are pitch and yaw angles of the IDP ray, and ri is the
%   inverse of the distance (wrongly named "inverse depth")
%
%   [U,S] = PINHOLEIDP(...) returns the vector S of depths from the camera
%   center.
%
%   [U,S,U_p,U_k,U_d] = PINHOLEIDP(...) returns the Jacobians of U wrt I, K
%   and D. It only works for single IDP points, and for distortion vectors
%   D of up to 3 parameters D=[d2;d4;d6]. See DISTORT for information on
%   longer distortion vectors.
%
%   See also PINHOLE, INVPINHOLEIDP.


if nargout <= 2

    p = idp2p(i);
    switch nargin
        case 1
            [u,s] = pinHole(p);
        case 2
            [u,s] = pinHole(p,k);
        case 3
            [u,s] = pinHole(p,k,d);
    end
    
else % jacobians
    
    [p,P_i] = idp2p(i);
    switch nargin
        case 1
            [u,s,U_p] = pinHole(p);
        case 2
            [u,s,U_p,U_k] = pinHole(p,k);
        case 3
            [u,s,U_p,U_k,U_d] = pinHole(p,k,d);
    end
    U_i = U_p*P_i;

end

return

%% jac
syms x0 y0 z0 a b r u0 v0 au av d2 d4 d6 real
i = [x0;y0;z0;a;b;r];
k = [u0;v0;au;av];
d = [d2;d4;d6];

[u,s,U_i,U_k,U_d] = pinHoleIdp(i,k,d);

simplify(U_i - jacobian(u,i))
simplify(U_k - jacobian(u,k))
simplify(U_d - jacobian(u,d))