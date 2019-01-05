
% setup parameters

level = 7;

y_ticks = getCoeffsRetained( level);
x_str = {};
for( i = 1 : numel(y_ticks))
  x_str{i} = num2str(y_ticks(i));
end


index_signal = 1;

% counter = 1 -> show zerotrees
% counter = 2 -> true negative (some root node seemed to be a zerotree but
% this is not true)
index_counter = 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = { squeeze(osh_zerotrees(1,:,index_counter,:)) , ...
         squeeze(bioh_zerotrees(1,:,index_counter,:)) , ...
         squeeze(pwh_zerotrees(1,:,index_counter,:)) };
% data = { squeeze(osh_zerotrees(1,:,index_counter,:)) ./ (squeeze(osh_zerotrees(1,:,1,:)) + squeeze(osh_zerotrees(1,:,2,:))), ...
%          squeeze(bioh_zerotrees(1,:,index_counter,:)) ./ (squeeze(bioh_zerotrees(1,:,1,:)) + squeeze(bioh_zerotrees(1,:,2,:))), ...
%          squeeze(pwh_zerotrees(1,:,index_counter,:)) ./ (squeeze(pwh_zerotrees(1,:,1,:)) + squeeze(pwh_zerotrees(1,:,2,:)))};  

max_data = 0;
for( basis = 1 : 3)
  
  basis_data = data{basis};
  
  % scale the counter for each level by the total number of nodes on the
  % level, i.e. normalize the data
  for( i = 1 : size( basis_data, 2))
    basis_data(:,i) = basis_data(:,i) / (8 * 3 * 4^(i-1));    
  end
  
  % some rescaling for better visibility
  basis_data = basis_data * 2;

  max_data = max( [max_data, max(basis_data(:))]);
  
  data{basis} = basis_data;
  
end

basis_str = {'SOHO', 'Bio-Haar', 'Pseudo Haar'};         
% xlabel_str = 'Level of Zerotree Root';
% ylabel_str = 'Coefficients Retained';
% zlabel_str = 'Number of Roots';
xlabel_str = 'X';
ylabel_str = 'Y';
zlabel_str = 'Z';
  
% get colormap to get identical mapping
cmap = colormap;
close;

% do  for all bases    
for( basis = 1 : numel( data))

  basis_data = data{basis};
  
  % find current mapping for colormap
  c_max_data = max( basis_data(:));
  c_max_index = int16( (size( cmap, 1) * c_max_data) / max_data);
  c_cmap = cmap( 1:c_max_index, :);

  % visualize
  figure;
  surf( basis_data)
  colormap( c_cmap);
  
  axis equal;
  campos( [-9.7146  -23.8997   20.5152]);
  
  set(gca,'XTick',[1 2 3 4 5 6 7]);
  set(gca,'XTickLabel',[1 2 3 4 5 6 7]);
  
  zlim( [0 1.2]);
  set(gca,'YTick',[1 : numel(x_str)]);
  set(gca,'YTickLabel', x_str);
  
  % colorbar;
  
  title( basis_str{basis});
  xlabel( xlabel_str);
  ylabel( ylabel_str);
  % zlabel( zlabel_str); 
  
  set(gca,'FontName','helvetica', 'FontSize',14);
  set(get(gca,'XLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'YLabel'),'FontName','helvetica', 'FontSize',14);
  set(get(gca,'ZLabel'),'FontName','helvetica', 'FontSize',14);  
  set(get(gca,'Title'),'FontName','helvetica', 'FontSize',14);
  
end

