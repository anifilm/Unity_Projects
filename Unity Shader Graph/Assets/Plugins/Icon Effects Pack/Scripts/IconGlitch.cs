using UnityEngine;
using UnityEngine.UI;

namespace IndieImpulseAssets
{
    public class IconGlitch : MonoBehaviour
    {
        // Reference to the UI Image component
        public Image uiImage;

        // Reference to the RectTransform of the UI Image for movement
        public RectTransform rectTransform;

        // The float value that will change randomly and modify the material property
        public float glitchValue;

        // Control how much randomness can happen
        public float minValue = 0f;
        public float maxValue = 50f;

        // Control how long the glitch value will stay at a random value
        public float minChangeDuration = 1f;
        public float maxChangeDuration = 3f;

        // Delay time between random value changes (before the glitch happens)
        public float minDelay = 1f;
        public float maxDelay = 3f;

        // Time variables
        private float timer;
        private float changeDuration;
        private float delay;
        private bool isChanging;

        // Store original position of the RectTransform for resetting after glitch
        private Vector3 originalPosition;

        // Movement variables for the glitch effect
        public float maxGlitchMovement = 10f;  // Maximum amount of movement in any direction

        void Start()
        {
            // Initial setup
            if (uiImage == null)
            {
                uiImage = GetComponent<Image>();  // Automatically fetch Image if not assigned
            }

            if (rectTransform == null)
            {
                rectTransform = GetComponent<RectTransform>();  // Automatically fetch RectTransform if not assigned
            }

            glitchValue = 0f;  // Initial value set to 0
            originalPosition = rectTransform.localPosition;  // Save the original position of the RectTransform
            SetRandomDelay();  // Set the initial delay
            SetRandomChangeDuration();  // Set initial random change duration
            isChanging = false;  // Start with no change happening
        }

        void Update()
        {
            timer += Time.deltaTime;

            // If glitch value is not changing, wait for the random delay
            if (!isChanging)
            {
                if (timer >= delay)
                {
                    // Set the glitch value to a random value between minValue and maxValue
                    glitchValue = Random.Range(minValue, maxValue);

                    // Apply a random movement to the RectTransform for the glitch effect
                    ApplyGlitchMovement();

                    isChanging = true;  // Start the glitch value change process
                    timer = 0f;  // Reset the timer to track how long the glitch stays
                    SetRandomChangeDuration();  // Set the duration for how long the glitch value will stay
                }
            }
            else
            {
                // If the glitch value is changing, keep it until the change duration has passed
                if (timer >= changeDuration)
                {
                    glitchValue = 0f;  // Reset the glitch value back to 0

                    // Reset the position back to the original position
                    rectTransform.localPosition = originalPosition;

                    isChanging = false;  // Stop changing, now wait for the next delay
                    timer = 0f;  // Reset the timer for the delay period
                    SetRandomDelay();  // Set a new random delay before next glitch
                }
            }

            // Access the material of the Image and set the "_Glitch" property
            if (uiImage.material.HasProperty("_Glitch")) // Ensure _Glitch property exists
            {
                uiImage.material.SetFloat("_Glitch", glitchValue);  // Set the _Glitch property
            }
        }

        void SetRandomDelay()
        {
            // Set a new random delay between minDelay and maxDelay before changing glitch value
            delay = Random.Range(minDelay, maxDelay);
        }

        void SetRandomChangeDuration()
        {
            // Set a new random duration for how long the glitch value will stay before resetting to 0
            changeDuration = Random.Range(minChangeDuration, maxChangeDuration);
        }

        void ApplyGlitchMovement()
        {
            // Apply random movement to the RectTransform for a glitch effect
            float randomX = Random.Range(-maxGlitchMovement, maxGlitchMovement);
            float randomY = Random.Range(-maxGlitchMovement, maxGlitchMovement);

            // Apply the random movement to the RectTransform's local position
            rectTransform.localPosition = new Vector3(randomX, randomY, originalPosition.z);
        }
    }
}