// NextGen Meet Design Tokens
// Hệ thống thiết kế lấy cảm hứng từ thanhnguyen.group

const NextGenDesignTokens = {
    // === MÀU SẮC ===
    color: {
        // Backgrounds - Nền tối chuyên nghiệp
        background: {
            primary: '#0A0A0A',      // Nền chính của ứng dụng
            secondary: '#1A1A1A',    // Nền cho các panel, card, thanh công cụ
            tertiary: '#2A2A2A',     // Nền cho các thành phần phụ
            overlay: 'rgba(0, 0, 0, 0.8)', // Overlay cho modal, popup
            glass: 'rgba(26, 26, 26, 0.8)' // Hiệu ứng kính mờ
        },
        
        // Text - Hệ thống màu chữ rõ ràng
        text: {
            primary: '#EAEAEA',      // Văn bản chính, tiêu đề
            secondary: '#A0A0A0',    // Văn bản phụ, metadata, placeholder
            onPrimary: '#FFFFFF',    // Văn bản trên nền màu nhấn
            onSecondary: '#000000',  // Văn bản trên nền sáng
            disabled: '#666666'      // Văn bản bị vô hiệu hóa
        },
        
        // Accent Colors - Màu nhấn đặc trưng
        accent: {
            primary: '#00F5A0',      // Teal - màu nhấn chính
            primaryHover: '#33FFB8', // Teal hover
            primaryGlow: 'rgba(0, 245, 160, 0.5)', // Teal glow effect
            secondary: '#A32EFF',    // Magenta - màu nhấn phụ
            secondaryHover: '#B84DFF', // Magenta hover
            secondaryGlow: 'rgba(163, 46, 255, 0.5)', // Magenta glow
            error: '#FF4D4D',        // Màu lỗi
            warning: '#FFC107',      // Màu cảnh báo
            success: '#4CAF50'       // Màu thành công
        },
        
        // Brand Gradient - Gradient thương hiệu
        brand: {
            gradient: 'linear-gradient(90deg, #00F5A0, #A32EFF)',
            gradientVertical: 'linear-gradient(180deg, #00F5A0, #A32EFF)',
            gradientDiagonal: 'linear-gradient(135deg, #00F5A0, #A32EFF)'
        },
        
        // Border - Hệ thống viền
        border: {
            default: '#333333',      // Viền mặc định
            light: '#444444',        // Viền nhẹ
            accent: '#00F5A0',       // Viền màu nhấn
            error: '#FF4D4D'         // Viền lỗi
        }
    },

    // === TYPOGRAPHY ===
    typography: {
        fontFamily: {
            primary: '"Inter", "Roboto", "Helvetica Neue", Arial, sans-serif',
            mono: '"JetBrains Mono", "Fira Code", "Consolas", monospace'
        },
        fontSize: {
            xs: '12px',      // Extra small
            sm: '14px',      // Small
            base: '16px',    // Base (body)
            lg: '18px',      // Large
            xl: '24px',      // Extra large
            '2xl': '36px',   // 2X large
            '3xl': '48px',   // 3X large
            '4xl': '64px'    // 4X large
        },
        fontWeight: {
            light: 300,
            regular: 400,
            medium: 500,
            semibold: 600,
            bold: 700,
            extrabold: 800
        },
        lineHeight: {
            tight: 1.2,
            normal: 1.5,
            relaxed: 1.75
        }
    },

    // === SPACING ===
    spacing: {
        unit: 8,            // Đơn vị cơ sở
        px: '1px',          // 1px
        '0.5': '4px',       // 0.5x unit
        '1': '8px',         // 1x unit
        '1.5': '12px',      // 1.5x unit
        '2': '16px',        // 2x unit
        '3': '24px',        // 3x unit
        '4': '32px',        // 4x unit
        '5': '40px',        // 5x unit
        '6': '48px',        // 6x unit
        '8': '64px',        // 8x unit
        '10': '80px',       // 10x unit
        '12': '96px',       // 12x unit
        '16': '128px',      // 16x unit
        '20': '160px',      // 20x unit
        '24': '192px'       // 24x unit
    },

    // === BORDER RADIUS ===
    borderRadius: {
        none: '0',
        sm: '4px',          // Small
        base: '8px',        // Base
        md: '12px',         // Medium
        lg: '16px',         // Large
        xl: '24px',         // Extra large
        '2xl': '32px',      // 2X large
        full: '9999px',     // Full (circle)
        circle: '50%'       // Circle
    },

    // === SHADOWS & EFFECTS ===
    shadow: {
        // Glow effects - Hiệu ứng phát sáng đặc trưng
        glow: {
            primary: '0 0 15px rgba(0, 245, 160, 0.5)',
            secondary: '0 0 15px rgba(163, 46, 255, 0.5)',
            error: '0 0 15px rgba(255, 77, 77, 0.5)',
            subtle: '0 0 8px rgba(0, 245, 160, 0.3)'
        },
        
        // Traditional shadows
        sm: '0 1px 2px rgba(0, 0, 0, 0.05)',
        base: '0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06)',
        md: '0 4px 6px rgba(0, 0, 0, 0.1), 0 2px 4px rgba(0, 0, 0, 0.06)',
        lg: '0 10px 15px rgba(0, 0, 0, 0.1), 0 4px 6px rgba(0, 0, 0, 0.05)',
        xl: '0 20px 25px rgba(0, 0, 0, 0.1), 0 10px 10px rgba(0, 0, 0, 0.04)',
        '2xl': '0 25px 50px rgba(0, 0, 0, 0.25)',
        
        // Special shadows
        inner: 'inset 0 2px 4px rgba(0, 0, 0, 0.06)',
        focus: '0 0 0 3px rgba(0, 245, 160, 0.5)',
        popup: '0px 8px 24px rgba(0, 0, 0, 0.5)'
    },

    // === TRANSITIONS ===
    transition: {
        fast: '0.15s ease-in-out',
        base: '0.2s ease-in-out',
        slow: '0.3s ease-in-out',
        slower: '0.5s ease-in-out',
        
        // Specific transitions
        color: 'color 0.2s ease-in-out',
        background: 'background-color 0.2s ease-in-out',
        border: 'border-color 0.2s ease-in-out',
        shadow: 'box-shadow 0.2s ease-in-out',
        transform: 'transform 0.2s ease-in-out',
        opacity: 'opacity 0.2s ease-in-out'
    },

    // === Z-INDEX ===
    zIndex: {
        hide: -1,
        auto: 'auto',
        base: 0,
        docked: 10,
        dropdown: 1000,
        sticky: 1100,
        banner: 1200,
        overlay: 1300,
        modal: 1400,
        popover: 1500,
        skipLink: 1600,
        toast: 1700,
        tooltip: 1800
    },

    // === BREAKPOINTS ===
    breakpoint: {
        xs: '0px',
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2xl': '1536px'
    },

    // === COMPONENT SPECIFIC ===
    component: {
        // Button heights
        buttonHeight: {
            sm: '32px',
            base: '40px',
            lg: '48px',
            xl: '56px'
        },
        
        // Input heights
        inputHeight: {
            sm: '32px',
            base: '40px',
            lg: '48px',
            xl: '56px'
        },
        
        // Toolbar
        toolbar: {
            height: '64px',
            borderRadius: '12px',
            padding: '8px'
        },
        
        // Video thumbnails
        thumbnail: {
            borderRadius: '12px',
            borderWidth: '2px',
            borderColor: 'transparent',
            borderColorActive: '#00F5A0'
        }
    }
};

// === CSS VARIABLES GENERATOR ===
// Tạo CSS variables từ design tokens
const generateCSSVariables = (tokens, prefix = '--nextgen') => {
    const cssVars = {};
    
    const processObject = (obj, currentPrefix = '') => {
        Object.keys(obj).forEach(key => {
            const value = obj[key];
            const varName = `${prefix}${currentPrefix}-${key}`;
            
            if (typeof value === 'object' && value !== null) {
                processObject(value, `${currentPrefix}-${key}`);
            } else {
                cssVars[varName] = value;
            }
        });
    };
    
    processObject(tokens);
    return cssVars;
};

// === MIXINS ===
// Các mixin tái sử dụng cho JSS
const NextGenMixins = {
    // Glow effect mixin
    glowEffect: (color, intensity = 0.5) => ({
        transition: 'box-shadow 0.2s ease-in-out',
        '&:hover': {
            boxShadow: `0 0 15px ${color}${Math.round(intensity * 255).toString(16).padStart(2, '0')}`
        }
    }),
    
    // Focus ring mixin
    focusRing: (color = '#00F5A0') => ({
        '&:focus': {
            outline: 'none',
            boxShadow: `0 0 0 3px ${color}80`
        }
    }),
    
    // Glass effect mixin
    glassEffect: (opacity = 0.8) => ({
        backgroundColor: `rgba(26, 26, 26, ${opacity})`,
        backdropFilter: 'blur(10px)',
        border: '1px solid rgba(255, 255, 255, 0.1)'
    }),
    
    // Smooth transition mixin
    smoothTransition: (properties = ['all']) => ({
        transition: properties.map(prop => `${prop} 0.2s ease-in-out`).join(', ')
    }),
    
    // Button base mixin
    buttonBase: {
        display: 'inline-flex',
        alignItems: 'center',
        justifyContent: 'center',
        border: 'none',
        borderRadius: '8px',
        cursor: 'pointer',
        fontWeight: 500,
        transition: 'all 0.2s ease-in-out',
        '&:disabled': {
            opacity: 0.5,
            cursor: 'not-allowed'
        }
    }
};

// Export cho sử dụng
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { NextGenDesignTokens, generateCSSVariables, NextGenMixins };
} else {
    window.NextGenDesignTokens = NextGenDesignTokens;
    window.generateCSSVariables = generateCSSVariables;
    window.NextGenMixins = NextGenMixins;
}
