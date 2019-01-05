function w = transform_weights(wo, n, v, rot, ae)
w = wo;
%Get the average weight (abs) and invert
% ae = (n+1)^2/sum(abs(wo)); %Mean equitorial radius
% ae = sum(abs(wo))/(n+1)^2;
% ae = numel(wo);
%if rot(2) ~= 0
    for l = 0:n
        for m = -l:l
            i = l^2+l+m+1;
            w(i) = find_coeff_trans(wo, l, m, v, ae);
        end
        %Split into seperate loops as both find_coeff functions depend on
        %values of w for m:-l:l
%         wo = w;
%         for m = -l:l
%             i = l^2+l+m+1;
%             w(i) = find_coeff_rot(wo, l, m, rot);
%         end
    end

% else
%     for l = 0:n
%         for m = -l:l
%             i = l^2+l+m+1;
%             w(i) = find_coeff_trans(wo, l, m, v, ae);
%         end
%     end
%     alpha = rot(1)+rot(3);
%     wo = w;
%     for m = -l:l
%         i = l^2+l+m+1;
%         w(i) = wo(i)*exp(-1i*m*alpha);
%     end
% end

end