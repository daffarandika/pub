import rclpy
from rclpy.node import Node
from sensor_msgs.msg import Image
from cv_bridge import CvBridge
import cv2


class USBImagePublisher(Node):
    def __init__(self):
        super().__init__('usb_image_publisher')
        self.publisher = self.create_publisher(Image, 'usb_camera/image_raw', 10)
        self.bridge = CvBridge()
        self.capture = cv2.VideoCapture(0)

        self.timer = self.create_timer(0.1, self.publish_image)

    def publish_image(self):
        ret, frame = self.capture.read()
        if ret:
            img_msg = self.bridge.cv2_to_imgmsg(frame, "bgr8")
            self.publisher.publish(img_msg)


def main(args=None):
    rclpy.init(args=args)
    usb_image_publisher = USBImagePublisher()
    rclpy.spin(usb_image_publisher)
    usb_image_publisher.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()