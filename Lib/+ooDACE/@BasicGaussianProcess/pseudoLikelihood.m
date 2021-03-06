%> @file "@BasicGaussianProcess/pseudoLikelihood.m"
%> @authors Ivo Couckuyt
%> @version 1.4 ($Revision$)
%> @date $LastChangedDate$
%> @date Copyright 2010-2013
%>
%> This file is part of the ooDACE toolbox
%> and you can redistribute it and/or modify it under the terms of the
%> GNU Affero General Public License version 3 as published by the
%> Free Software Foundation.  With the additional provision that a commercial
%> license must be purchased if the ooDACE toolbox is used, modified, or extended
%> in a commercial setting. For details see the included LICENSE.txt file.
%> When referring to the ooDACE toolbox please make reference to the corresponding
%> publications:
%>   - Blind Kriging: Implementation and performance analysis
%>     I. Couckuyt, A. Forrester, D. Gorissen, F. De Turck, T. Dhaene,
%>     Advances in Engineering Software,
%>     Vol. 49, pp. 1-13, July 2012.
%>   - Surrogate-based infill optimization applied to electromagnetic problems
%>     I. Couckuyt, F. Declercq, T. Dhaene, H. Rogier, L. Knockaert,
%>     International Journal of RF and Microwave Computer-Aided Engineering (RFMiCAE),
%>     Special Issue on Advances in Design Optimization of Microwave/RF Circuits and Systems,
%>     Vol. 20, No. 5, pp. 492-501, September 2010. 
%>
%> Contact : ivo.couckuyt@ugent.be - http://sumo.intec.ugent.be/?q=ooDACE
%> Signature
%>	[out dout] = pseudoLikelihood(this, dpsi, dsigma2)
%
% ======================================================================
%> Calculates the leave-one-out predictive log probability
%>
%> Papers:
%> - "Predictive Approaches for Choosing Hyperparameters in Gaussian Process",
%>      S. Sundararajan, S.S. Keerthu, 1999
% ======================================================================
function [out, dout] = pseudoLikelihood(this, dpsi, dsigma2)
	
    F = this.C * this.Ft;
    residual = this.values(this.P,:)-F*this.alpha; % residual
	
    Kinv = inv(this.C * this.C') ./ this.sigma2;
    Kinvy = Kinv * residual; % alpha
    
    mu = residual - Kinvy ./ diag(Kinv);
    sigma2 = 1 ./ diag(Kinv);

    %% leave-one-out predictive log probability
    cv = 0.5 .* log(sigma2) + (residual-mu).^2 ./ (2.*sigma2) + 0.5 .* log(2.*pi);
	out = sum(cv);
    
    %% Derivatives (analytical)
    if nargout > 1
        if size( this.regressionFcn, 1 ) > 0
            error('BasicGaussianProcess:pseudoLikelihood: Derivatives not supported when regression function is not 0.'); 
        end

        dout = zeros( 1, length(dpsi) );
        for j=1:length(dpsi)
          dpsiCurr = dpsi{j} + dpsi{j}';
          dpsiCurr = dpsiCurr .* this.sigma2;

          Zj = Kinv.' * dpsiCurr;
          v1 = Zj*Kinvy;
          v2 = Zj*Kinv;

          tmp = 0.5 .* (1 + Kinvy.^2 ./ diag(Kinv)).*diag(v2);
          tmp = tmp - Kinvy.*v1;
          dout(:,j) = sum(tmp ./ diag(Kinv));
        end
    end
end
