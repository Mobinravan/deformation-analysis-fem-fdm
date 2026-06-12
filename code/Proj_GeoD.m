% Mobin ravan
% Phobos
clear; clc; close all;

%% Parameter Definitions

% Total page dimensions
width = 10000;   % 10 km
height = 5000;   % 5 km

% Defining page boundaries
horizontal_boundary = height / 2;   % 2500 meters
vertical_boundary = width / 2;       % 5000 meters

%% ==================== Grid Points Generation (Random) ====================

n_points_per_page = 30;   % 30 points per page

% Plate A: Upper half (y >= 2500, 0 <= x <= 10000)
xA = rand(n_points_per_page, 1) * width;
yA = rand(n_points_per_page, 1) * (height - horizontal_boundary) + horizontal_boundary;

% Plate B: Bottom-Right (x >= 5000, y < 2500)
xB = rand(n_points_per_page, 1) * (width - vertical_boundary) + vertical_boundary;
yB = rand(n_points_per_page, 1) * horizontal_boundary;

% Plate C: Bottom-Left (x < 5000, y < 2500)
xC = rand(n_points_per_page, 1) * vertical_boundary;
yC = rand(n_points_per_page, 1) * horizontal_boundary;

% Combining all points
X_initial = [xA; xB; xC];
Y_initial = [yA; yB; yC];
n_points = length(X_initial);

%% ==================== Displacement Field Definition (200 m) ====================

% Plate A: Movement towards bottom-left (South-West)
Ux_A = -171.5;
Uy_A = -102.9;

% Plate B: Movement towards top-left (North-West)
Ux_B = -156.2;
Uy_B = +124.9;

% Plate C: Rotational movement around center (2500, 1250)
center_C_x = 2500;
center_C_y = 1250;
rotation_deg = 5;
rotation_rad = rotation_deg * pi / 180;

% Calculating displacement vectors for each point
Ux_initial = zeros(n_points, 1);
Uy_initial = zeros(n_points, 1);

for i = 1:n_points
    x = X_initial(i);
    y = Y_initial(i);
    
    if y >= horizontal_boundary
        % Plate A
        Ux_initial(i) = Ux_A;
        Uy_initial(i) = Uy_A;
    elseif x >= vertical_boundary
        % Plate B
        Ux_initial(i) = Ux_B;
        Uy_initial(i) = Uy_B;
    else
        % Plate C - Rotational
        dx = x - center_C_x;
        dy = y - center_C_y;
        Ux_initial(i) = dx * (cos(rotation_rad) - 1) - dy * sin(rotation_rad);
        Uy_initial(i) = dx * sin(rotation_rad) + dy * (cos(rotation_rad) - 1);
    end
end

% Final coordinates of points
X_final = X_initial + Ux_initial;
Y_final = Y_initial + Uy_initial;

%% ==================== Figure 1: Displacement Vectors (Separate) ====================

figure('Position', [100, 100, 1000, 800]);
hold on;

% Plotting displacement vectors (red arrows)
quiver(X_initial, Y_initial, Ux_initial, Uy_initial, 'r', 'LineWidth', 2, 'AutoScale', 'off');

% Plotting initial (blue) and final (cyan) points
plot(X_initial, Y_initial, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
plot(X_final, Y_final, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'c');

% Plotting boundaries
plot([0, width], [horizontal_boundary, horizontal_boundary], 'r-', 'LineWidth', 2.5);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'r-', 'LineWidth', 2.5);

% Writing plate names
text(width/2, 3*height/4, 'A', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');
text(3*width/4, height/4, 'B', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');
text(width/4, height/4, 'C', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');

% Axis settings
xlabel('X (m)', 'FontSize', 14);
ylabel('Y (m)', 'FontSize', 14);
title('Figure 1: Displacement Vectors Field (200 m)', 'FontSize', 16);
legend('Displacement Vectors', 'Initial', 'Final', 'Location', 'best');
axis equal;
grid on;
xlim([-500, 10500]);
ylim([-500, 5500]);

saveas(gcf, 'Figure1_Displacement_Vectors.jpg');

%% ==================== Figure 2: Network Deformation (Separate) ====================

figure('Position', [100, 100, 1000, 800]);
hold on;

% Plotting initial (blue) and final (cyan) points
plot(X_initial, Y_initial, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
plot(X_final, Y_final, 'ro', 'MarkerSize', 5, 'MarkerFaceColor', 'c');

% Plotting connection lines between initial and final points
for i = 1:n_points
    plot([X_initial(i), X_final(i)], [Y_initial(i), Y_final(i)], 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
end

% Plotting boundaries
plot([0, width], [horizontal_boundary, horizontal_boundary], 'r-', 'LineWidth', 2.5);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'r-', 'LineWidth', 2.5);

% Writing plate names
text(width/2, 3*height/4, 'A', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');
text(3*width/4, height/4, 'B', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');
text(width/4, height/4, 'C', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'r', ...
    'HorizontalAlignment', 'center');

% Axis settings
xlabel('X (m)', 'FontSize', 14);
ylabel('Y (m)', 'FontSize', 14);
title('Figure 2: Grid Deformation (Blue: Initial, Cyan: Final)', 'FontSize', 16);
legend('Initial', 'Final', 'Location', 'best');
axis equal;
grid on;
xlim([-500, 10500]);
ylim([-500, 5500]);

saveas(gcf, 'Figure2_Network_Deformation.jpg');

%% ==================== Figure 3: Displacement in X Direction (Separate) ====================

% Creating a regular grid for contour
x_grid_reg = linspace(0, width, 100);
y_grid_reg = linspace(0, height, 60);
[X_reg, Y_reg] = meshgrid(x_grid_reg, y_grid_reg);
Ux_reg = griddata(X_initial, Y_initial, Ux_initial, X_reg, Y_reg, 'natural');

figure('Position', [100, 100, 1000, 800]);
hold on;

% Plotting filled contour of displacement in X direction
contourf(X_reg, Y_reg, Ux_reg, 30, 'LineStyle', 'none');
colorbar;
colormap('jet');

% Plotting boundaries
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2.5);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2.5);

% Writing plate names
text(width/2, 3*height/4, 'A', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'k', ...
    'HorizontalAlignment', 'center');
text(3*width/4, height/4, 'B', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'k', ...
    'HorizontalAlignment', 'center');
text(width/4, height/4, 'C', 'FontSize', 20, 'FontWeight', 'bold', 'Color', 'k', ...
    'HorizontalAlignment', 'center');

% Axis settings
xlabel('X (m)', 'FontSize', 14);
ylabel('Y (m)', 'FontSize', 14);
title('Figure 3: Displacement in X Direction (m)', 'FontSize', 16);
axis equal;
grid on;
xlim([-500, 10500]);
ylim([-500, 5500]);

saveas(gcf, 'Figure3_Displacement_X.jpg');

%% ==================== Continuation: Finite Difference Method (FDM) ====================

n_x_fdm = 50;
n_y_fdm = 30;
x_fdm = linspace(0, width, n_x_fdm);
y_fdm = linspace(0, height, n_y_fdm);
[X_fdm, Y_fdm] = meshgrid(x_fdm, y_fdm);

Ux_fdm = griddata(X_initial, Y_initial, Ux_initial, X_fdm, Y_fdm, 'natural');
Uy_fdm = griddata(X_initial, Y_initial, Uy_initial, X_fdm, Y_fdm, 'natural');

dx_fdm = x_fdm(2) - x_fdm(1);
dy_fdm = y_fdm(2) - y_fdm(1);

E_xx_FDM = zeros(n_y_fdm, n_x_fdm);
E_yy_FDM = zeros(n_y_fdm, n_x_fdm);
E_xy_FDM = zeros(n_y_fdm, n_x_fdm);
Rotation_FDM = zeros(n_y_fdm, n_x_fdm);

for i = 2:n_y_fdm-1
    for j = 2:n_x_fdm-1
        dUx_dx = (Ux_fdm(i, j+1) - Ux_fdm(i, j-1)) / (2 * dx_fdm);
        dUx_dy = (Ux_fdm(i+1, j) - Ux_fdm(i-1, j)) / (2 * dy_fdm);
        dUy_dx = (Uy_fdm(i, j+1) - Uy_fdm(i, j-1)) / (2 * dx_fdm);
        dUy_dy = (Uy_fdm(i+1, j) - Uy_fdm(i-1, j)) / (2 * dy_fdm);
        
        E_xx_FDM(i, j) = dUx_dx;
        E_yy_FDM(i, j) = dUy_dy;
        E_xy_FDM(i, j) = 0.5 * (dUx_dy + dUy_dx);
        Rotation_FDM(i, j) = 0.5 * (dUy_dx - dUx_dy);
    end
end

Dilatation_FDM = E_xx_FDM + E_yy_FDM;
MaxShear_FDM = sqrt(((E_xx_FDM - E_yy_FDM)/2).^2 + E_xy_FDM.^2);

% Edge padding / boundary filling
Dilatation_FDM(1,:) = Dilatation_FDM(2,:);
Dilatation_FDM(end,:) = Dilatation_FDM(end-1,:);
Dilatation_FDM(:,1) = Dilatation_FDM(:,2);
Dilatation_FDM(:,end) = Dilatation_FDM(:,end-1);

MaxShear_FDM(1,:) = MaxShear_FDM(2,:);
MaxShear_FDM(end,:) = MaxShear_FDM(end-1,:);
MaxShear_FDM(:,1) = MaxShear_FDM(:,2);
MaxShear_FDM(:,end) = MaxShear_FDM(:,end-1);

Rotation_FDM(1,:) = Rotation_FDM(2,:);
Rotation_FDM(end,:) = Rotation_FDM(end-1,:);
Rotation_FDM(:,1) = Rotation_FDM(:,2);
Rotation_FDM(:,end) = Rotation_FDM(:,end-1);

%% ==================== Finite Element Method (FEM) ====================

TRI = delaunay(X_initial, Y_initial);
n_triangles = size(TRI, 1);

E_xx_FEM = zeros(n_triangles, 1);
E_yy_FEM = zeros(n_triangles, 1);
E_xy_FEM = zeros(n_triangles, 1);
Rotation_FEM = zeros(n_triangles, 1);

for k = 1:n_triangles
    idx = TRI(k, :);
    x_vertices = X_initial(idx);
    y_vertices = Y_initial(idx);
    ux_vertices = Ux_initial(idx);
    uy_vertices = Uy_initial(idx);
    
    A_mat = [ones(3,1), x_vertices, y_vertices];
    
    coeff_u = A_mat \ ux_vertices;
    coeff_v = A_mat \ uy_vertices;
    
    dUx_dx = coeff_u(2);
    dUx_dy = coeff_u(3);
    dUy_dx = coeff_v(2);
    dUy_dy = coeff_v(3);
    
    E_xx_FEM(k) = dUx_dx;
    E_yy_FEM(k) = dUy_dy;
    E_xy_FEM(k) = 0.5 * (dUx_dy + dUy_dx);
    Rotation_FEM(k) = 0.5 * (dUy_dx - dUx_dy);
end

Dilatation_FEM = E_xx_FEM + E_yy_FEM;
MaxShear_FEM = sqrt(((E_xx_FEM - E_yy_FEM)/2).^2 + E_xy_FEM.^2);

%% ==================== Figure 4: Comparison of FDM and FEM (6 Subplots) ====================

idx_show = 1:5:n_points;

figure('Position', [100, 100, 1600, 900]);

% ========== First Row: FDM ==========

% 1. Dilatation - FDM
subplot(2, 3, 1);
contourf(X_fdm, Y_fdm, Dilatation_FDM, 20, 'LineStyle', 'none');
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FDM: Dilatation + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]); colormap('jet');

% 2. Maximum Shear - FDM
subplot(2, 3, 2);
contourf(X_fdm, Y_fdm, MaxShear_FDM, 20, 'LineStyle', 'none');
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FDM: Maximum Shear + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 3. Rotation - FDM
subplot(2, 3, 3);
contourf(X_fdm, Y_fdm, Rotation_FDM, 20, 'LineStyle', 'none');
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FDM: Rotation + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% ========== Second Row: FEM ==========

% 4. Dilatation - FEM
subplot(2, 3, 4);
trisurf(TRI, X_initial, Y_initial, zeros(size(X_initial)), Dilatation_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
view(2); colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FEM: Dilatation on Triangles + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 5. Maximum Shear - FEM
subplot(2, 3, 5);
trisurf(TRI, X_initial, Y_initial, zeros(size(X_initial)), MaxShear_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
view(2); colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FEM: Maximum Shear + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 6. Rotation - FEM
subplot(2, 3, 6);
trisurf(TRI, X_initial, Y_initial, zeros(size(X_initial)), Rotation_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
view(2); colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 12, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('FEM: Rotation + Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

annotation('textbox', [0 0.95 1 0.05], 'String', 'Figure 4: Comparison of FDM and FEM Methods (200m, Random Points)', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'Figure4_FDM_vs_FEM.jpg');

%% ==================== Figure 5: Details of FEM Results (4 Subplots) ====================

figure('Position', [100, 100, 1200, 800]);

% 1. Triangulation
subplot(2, 2, 1);
triplot(TRI, X_initial, Y_initial, 'b-', 'LineWidth', 0.5);
hold on;
plot(X_initial, Y_initial, 'ro', 'MarkerSize', 3);
plot([0, width], [horizontal_boundary, horizontal_boundary], 'k-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'k-', 'LineWidth', 2);
text(width/2, 3*height/4, 'A', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
text(3*width/4, height/4, 'B', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
text(width/4, height/4, 'C', 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
xlabel('X (m)'); ylabel('Y (m)'); title('Delaunay Triangulation');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 2. Dilatation with Vectors
subplot(2, 2, 2);
patch('Faces', TRI, 'Vertices', [X_initial, Y_initial], 'FaceVertexCData', Dilatation_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
xlabel('X (m)'); ylabel('Y (m)'); title('Dilatation (\Delta) + Displacement Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 3. Maximum Shear with Vectors
subplot(2, 2, 3);
patch('Faces', TRI, 'Vertices', [X_initial, Y_initial], 'FaceVertexCData', MaxShear_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
xlabel('X (m)'); ylabel('Y (m)'); title('Maximum Shear (\Gamma_{max}) + Displacement Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

% 4. Rotation with Vectors
subplot(2, 2, 4);
patch('Faces', TRI, 'Vertices', [X_initial, Y_initial], 'FaceVertexCData', Rotation_FEM, ...
    'FaceColor', 'flat', 'EdgeColor', 'k', 'LineWidth', 0.3);
colorbar; hold on;
quiver(X_initial(idx_show), Y_initial(idx_show), Ux_initial(idx_show), Uy_initial(idx_show), ...
    'k', 'LineWidth', 1.5, 'AutoScale', 'off');
plot([0, width], [horizontal_boundary, horizontal_boundary], 'w-', 'LineWidth', 2);
plot([vertical_boundary, vertical_boundary], [0, horizontal_boundary], 'w-', 'LineWidth', 2);
xlabel('X (m)'); ylabel('Y (m)'); title('Rotation (\Phi) + Displacement Vectors');
axis equal; xlim([-500,10500]); ylim([-500,5500]);

annotation('textbox', [0 0.95 1 0.05], 'String', 'Figure 5: FEM Results with Displacement Vectors', ...
    'EdgeColor', 'none', 'HorizontalAlignment', 'center', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'Figure5_FEM_Details.jpg');

%% ==================== Statistical Analysis ====================

idx_A = (Y_initial >= horizontal_boundary);
idx_B = (X_initial >= vertical_boundary) & (Y_initial < horizontal_boundary);
idx_C = (X_initial < vertical_boundary) & (Y_initial < horizontal_boundary);

fprintf('\n========== Statistical Analysis Results ==========\n\n');

fprintf('Plate A (Upper Half - Movement Towards South-West):\n');
fprintf('  Mean Dilatation: %.2e\n', mean(Dilatation_FEM(idx_A)));
fprintf('  Mean Maximum Shear: %.2e\n', mean(MaxShear_FEM(idx_A)));
fprintf('  Mean Rotation: %.2e\n\n', mean(Rotation_FEM(idx_A)));

fprintf('Plate B (Bottom-Right - Movement Towards North-West):\n');
fprintf('  Mean Dilatation: %.2e\n', mean(Dilatation_FEM(idx_B)));
fprintf('  Mean Maximum Shear: %.2e\n', mean(MaxShear_FEM(idx_B)));
fprintf('  Mean Rotation: %.2e\n\n', mean(Rotation_FEM(idx_B)));

fprintf('Plate C (Bottom-Left - Rotational Movement):\n');
fprintf('  Mean Dilatation: %.2e\n', mean(Dilatation_FEM(idx_C)));
fprintf('  Mean Maximum Shear: %.2e\n', mean(MaxShear_FEM(idx_C)));
fprintf('  Mean Rotation: %.2e\n\n', mean(Rotation_FEM(idx_C)));

%% ==================== Saving Results ====================

save('results_strain_analysis_final.mat', 'X_initial', 'Y_initial', 'Ux_initial', 'Uy_initial', ...
    'Dilatation_FEM', 'MaxShear_FEM', 'Rotation_FEM', 'TRI');

fprintf('\n========== Full Saving Completed ==========\n\n');
fprintf('5 Final Figures:\n');
fprintf('   Figure1_Displacement_Vectors.jpg - Figure 1: Displacement Vectors Field\n');
fprintf('   Figure2_Network_Deformation.jpg - Figure 2: Grid Deformation\n');
fprintf('   Figure3_Displacement_X.jpg - Figure 3: Displacement in X Direction\n');
fprintf('   Figure4_FDM_vs_FEM.jpg - Figure 4: FDM and FEM Comparison (6 Subplots)\n');
fprintf('   Figure5_FEM_Details.jpg - Figure 5: FEM Details (4 Subplots)\n');
