namespace CairoLines {
    
    public class MovingPoint {
        public double x;
        public double y;
        public double dx;
        public double dy;
        
        public void init(float width, float height, double minStep) {
            x = (width - 1) * Random.next_double();
            y = (height - 1) * Random.next_double();
            dx = (Random.next_double() * minStep * 2) + 1;
            dy = (Random.next_double() * minStep * 2) + 1;
        }
        
        public double adjDelta(double cur, double minStep, double maxStep) {
            cur += (Random.next_double() * minStep) - (minStep / 2);
            if (cur < 0 && cur > -minStep) cur = -minStep;
            if (cur >= 0 && cur < minStep) cur = minStep;
            if (cur > maxStep) cur = maxStep;
            if (cur < -maxStep) cur = -maxStep;
            return cur;
        }
        
        public void step(int width, int height, double minStep, double maxStep) {
            x += dx;
            if (x <= 0 || x >= (width - 1)) {
                if (x <= 0) x = 0;
                else if (x >= (width - 1)) x = width - 1;
                dx = adjDelta(-dx, minStep, maxStep);
            }
            y += dy;
            if (y <= 0 || y >= (height - 1)) {
                if (y <= 0) y = 0;
                else if (y >= (height - 1)) y = height - 1;
                dy = adjDelta(-dy, minStep, maxStep);
            }
        }
    }
}