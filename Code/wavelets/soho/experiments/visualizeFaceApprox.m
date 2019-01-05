x_min = 7168;
x_max = 8192;
y_min = -0.1;
y_max = 0.1;


subplot( 4, 2, 1);
bar( coeffs_fig1_1_analysed);
xlim([x_min x_max]);
ylim([y_min y_max]);

subplot( 4, 2, 2);
bar( coeffs_fig1_1_synth);
xlim([x_min x_max]);
ylim([y_min y_max]);


subplot( 4, 2, 3);
bar( coeffs_fig2_1_analysed);
xlim([x_min x_max]);
ylim([y_min y_max]);

subplot( 4, 2, 4);
bar( coeffs_fig2_1_synth);
xlim([x_min x_max]);
ylim([y_min y_max]);


subplot( 4, 2, 5);
bar( coeffs_fig3_1_analysed);
xlim([x_min x_max]);
ylim([y_min y_max]);

subplot( 4, 2, 6);
bar( coeffs_fig3_1_synth);
xlim([x_min x_max]);
ylim([y_min y_max]);


subplot( 4, 2, 7);
bar( coeffs_fig4_1_analysed);
xlim([x_min x_max]);
ylim([y_min y_max]);

subplot( 4, 2, 8);
bar( coeffs_fig4_1_synth);
xlim([x_min x_max]);
ylim([y_min y_max]);

