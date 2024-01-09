namespace CairoLines {
    
    [GtkTemplate (ui = "/me/paladin/CairoLines/ui/window.ui")]
    public class MainWindow : Adw.ApplicationWindow {
        [GtkChild]
        private unowned Gtk.DrawingArea area;
        
        const int NUM_OLD = 100;
        double min_step = 3;
        double max_step = 8;
        double line_size = 2;
        
        bool initialized;
        MovingPoint point1 = new MovingPoint();
        MovingPoint point2 = new MovingPoint();
        
        int num_old = 0;
        double[] old = new double[NUM_OLD*4];
        Gdk.RGBA[] old_color = new Gdk.RGBA[NUM_OLD];
        int bright_line = 0;
        
        Gdk.RGBA foreground = Gdk.RGBA();
        
        MovingPoint color = new MovingPoint();
        
        public MainWindow(Gtk.Application app) {
            Object(application: app);
            
            area.set_draw_func(draw);
            area.add_tick_callback(() => {
                area.queue_draw();
                return true;
            });
        }
        
        private float make_green(int index) {
            var dist = Math.fabsf(bright_line - index);
            if (dist > 10) return 0;
            return 1 - dist / 10;
        }
        
        private void draw(Gtk.DrawingArea area, Cairo.Context cr, int width, int height) {
            cr.set_line_width(line_size);
            
            if (!initialized) {
                initialized = true;
                point1.init(width, height, min_step);
                point2.init(width, height, min_step);
                color.init(127, 127, 1);
            } else {
                point1.step(width, height, min_step, max_step);
                point2.step(width, height, min_step, max_step);
                color.step(127, 127, 1, 3);
            }
            bright_line += 2;
            if (bright_line > (NUM_OLD * 2))
                bright_line = -2;
            
            for (int i = num_old - 1; i >= 0; i--) {
                old_color[i].green = make_green(i);
                foreground = old_color[i];
                foreground.alpha = (NUM_OLD - i) / (float) NUM_OLD;
                int p = i * 4;
                cr.set_source_rgba(foreground.red, foreground.green, foreground.blue, foreground.alpha);
                cr.move_to(old[p], old[p + 1]);
                cr.line_to(old[p + 2], old[p + 3]);
                cr.stroke();
            }
            
            foreground.red = (float) (color.x + 128) / 255;
            foreground.green = make_green(-2);
            foreground.blue = (float) (color.y + 128) / 255;
            foreground.alpha = 1;
            cr.set_line_width(1);
            cr.set_source_rgba(foreground.red, foreground.green, foreground.blue, foreground.alpha);
            cr.move_to(point1.x, point1.y);
            cr.line_to(point2.x, point2.y);
            cr.stroke();
            
            if (num_old > 1) {
                double[] temp_old = {};
                for (int i = 0; i < (num_old - 1) * 4; i++) {
                    temp_old += old[i];
                }
                for (int i = 4; i < (num_old - 1) * 4; i++) {
                    old[i] = temp_old[i - 4];
                }
                Gdk.RGBA[] temp_color = {};
                for (int i = 0; i < num_old - 1; i++) {
                    temp_color += old_color[i];
                }
                for (int i = 1; i < num_old - 1; i++) {
                    old_color[i] = temp_color[i - 1];
                }
            }
            
            if (num_old < NUM_OLD) num_old++;
            old[0] = point1.x;
            old[1] = point1.y;
            old[2] = point2.x;
            old[3] = point2.y;
            old_color[0] = foreground;
        }
    }
}
