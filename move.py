from time import sleep
from onvif import ONVIFCamera
import zeep


class MoveCamera:
    def __init__(self):
        self.XMAX = 1
        self.XMIN = -1
        self.YMAX = 1
        self.YMIN = -1

    def zeep_pythonvalue(self, xmlvalue):
        return xmlvalue

    def perform_move(self, ptz, request, timeout):
        # Start continuous move
        ptz.ContinuousMove(request)
        # Wait a certain time
        sleep(timeout)
        # Stop continuous move
        ptz.Stop({'ProfileToken': request.ProfileToken})

    def move_up(self, ptz, request, timeout=1):
        print('move up...')
        request.Velocity.PanTilt.x = 0
        request.Velocity.PanTilt.y = self.YMAX  # Set to maximum speed initially
        self.perform_move(ptz, request, timeout)

    def move_middle(self, ptz, request, timeout=1):
        print('move to middle...')
        request.Velocity.PanTilt.x = 0
        
        # Determine the middle position
        middle_position = (self.YMAX + self.YMIN) / 2
        
        # Set the initial speed towards YMAX
        request.Velocity.PanTilt.y = self.YMAX
        
        # Gradually decrease the speed to reach the middle position
        for _ in range(int(timeout * 10)):  # Adjust the number of steps as needed
            current_position = request.Velocity.PanTilt.y
            
            # Decrease the speed gradually
            if current_position > middle_position:
                request.Velocity.PanTilt.y -= abs(self.YMAX - self.YMIN) / 10
            else:
                request.Velocity.PanTilt.y += abs(self.YMAX - self.YMIN) / 10
            
            self.perform_move(ptz, request, 0.1)  # Move for a short duration
            
            # Stop when the camera reaches the middle position
            if abs(request.Velocity.PanTilt.y - middle_position) < 0.01:  # Adjust the tolerance as needed
                request.Velocity.PanTilt.y = 0  # Stop the camera
                self.perform_move(ptz, request, 0.1)  # Stop for a short duration
                break

    def move_down(self, ptz, request, timeout=1):
        print('move down...')
        request.Velocity.PanTilt.x = 0
        request.Velocity.PanTilt.y = self.YMIN  # Set to maximum speed initially
        self.perform_move(ptz, request, timeout)

    def move_right(self, ptz, request, timeout=1):
        print('move right...')
        request.Velocity.PanTilt.x = self.XMAX
        request.Velocity.PanTilt.y = 0
        self.perform_move(ptz, request, timeout)

    def move_left(self, ptz, request, timeout=1):
        print('move left...')
        request.Velocity.PanTilt.x = self.XMIN
        request.Velocity.PanTilt.y = 0
        self.perform_move(ptz, request, timeout)

    def move_sequence(self, ptz, request):
        for _ in range(2):  # Repeat the sequence 5 times
            # Full down to up in YMIN position
            for i in range(1):
                sleep(10)
                self.move_down(ptz, request)
    
            for i in range(3):
                sleep(10)
                self.move_left(ptz, request)
    
            for i in range(3):
                sleep(10)
                self.move_right(ptz, request)
    
            for i in range(1):
                sleep(10)
                self.move_middle(ptz, request)
    
            # Right to left in middle Y position
            for i in range(3):
                sleep(10)
                self.move_left(ptz, request)
    
            for i in range(3):
                sleep(10)
                self.move_right(ptz, request)
    
            for i in range(1):
                sleep(10)
                self.move_middle(ptz, request)
    
            for i in range(3):
                sleep(10)
                self.move_left(ptz, request)
    
            for i in range(3):
                sleep(10)
                self.move_right(ptz, request)
    
            for i in range(1):
                sleep(10)
                self.move_up(ptz, request)

    def continuous_move(self):
        mycam = ONVIFCamera('192.168.8.130', 8899, 'admin', 'admin#D23')
        # Create media service object
        media = mycam.create_media_service()
        # Create ptz service object
        ptz = mycam.create_ptz_service()
    
        # Get target profile
        zeep.xsd.simple.AnySimpleType.pythonvalue = self.zeep_pythonvalue
        media_profile = media.GetProfiles()[0]
    
        # Get PTZ configuration options for getting continuous move range
        request = ptz.create_type('GetConfigurationOptions')
        request.ConfigurationToken = media_profile.PTZConfiguration.token
        ptz_configuration_options = ptz.GetConfigurationOptions(request)
    
        request = ptz.create_type('ContinuousMove')
        request.ProfileToken = media_profile.token
        ptz.Stop({'ProfileToken': media_profile.token})
    
        if request.Velocity is None:
            request.Velocity = ptz.GetStatus({'ProfileToken': media_profile.token}).Position
            request.Velocity = ptz.GetStatus({'ProfileToken': media_profile.token}).Position
            request.Velocity.PanTilt.space = ptz_configuration_options.Spaces.ContinuousPanTiltVelocitySpace[0].URI
    
        # Get range of pan and tilt
        self.XMAX = ptz_configuration_options.Spaces.ContinuousPanTiltVelocitySpace[0].XRange.Max
        self.XMIN = ptz_configuration_options.Spaces.ContinuousPanTiltVelocitySpace[0].XRange.Min
        self.YMAX = ptz_configuration_options.Spaces.ContinuousPanTiltVelocitySpace[0].YRange.Max
        self.YMIN = ptz_configuration_options.Spaces.ContinuousPanTiltVelocitySpace[0].YRange.Min

        self.move_sequence(ptz, request)

# Usage:
# move_camera = MoveCamera()
# move_camera.continuous_move()
