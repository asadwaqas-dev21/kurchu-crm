const fs = require('fs');
const path = require('path');

const iconMap = {
  'person_outline': 'profile',
  'notifications_none': 'notification',
  'lock_outline': 'lock',
  'link': 'link',
  'credit_card': 'card',
  'search': 'search_normal',
  'call': 'call',
  'message': 'message',
  'filter_list': 'filter',
  'add': 'add',
  'chevron_left': 'arrow_left_2',
  'chevron_right': 'arrow_right_3',
  'map': 'map',
  'download': 'document_download',
  'print': 'printer',
  'phone': 'call',
  'person': 'user',
  'upload_file': 'document_upload',
  'folder': 'folder_2',
  'picture_as_pdf': 'document',
  'more_vert': 'more',
  'account_balance_wallet': 'wallet',
  'check_circle_outline': 'tick_circle',
  'pending_actions': 'clock',
  'trending_up': 'trend_up',
  'info': 'info_circle',
  'warning': 'warning_2',
  'error': 'close_circle',
  'warning_amber_rounded': 'warning_2',
  'event_busy': 'calendar_remove',
  'mail_outline': 'sms',
  'notifications_active_outlined': 'notification_status',
  'history': 'timer_1',
  'more_horiz': 'more',
  'keyboard_arrow_down': 'arrow_down_1',
  'people_outline': 'profile_2user',
  'phone_callback_outlined': 'call_calling',
  'turn_right': 'arrow_right_1',
  'calendar_today': 'calendar_1',
  'check_circle': 'tick_circle',
  'pie_chart_outline': 'chart',
  'article_outlined': 'document_text',
  'monetization_on_outlined': 'coin',
  'description_outlined': 'document_text',
  'settings_outlined': 'setting_2',
  'receipt_long_outlined': 'receipt',
  'view_kanban_outlined': 'kanban',
  'event_note_outlined': 'calendar_tick',
  'menu': 'menu_1',
  'notifications': 'notification',
  'keyboard_arrow_down_outlined': 'arrow_down_1',
  'check': 'tick_circle',
  'attach_file': 'attach_square',
  'close': 'close_circle',
  'home_outlined': 'home_2',
  'group_outlined': 'profile_2user',
  'insert_chart_outlined': 'chart_21',
  'account_circle_outlined': 'profile_circle'
};

function walkDir(dir, callback) {
  fs.readdirSync(dir).forEach(f => {
    let dirPath = path.join(dir, f);
    let isDirectory = fs.statSync(dirPath).isDirectory();
    isDirectory ? walkDir(dirPath, callback) : callback(dirPath);
  });
}

const libPath = path.join(__dirname, 'lib');
let changedFilesCount = 0;

walkDir(libPath, (filePath) => {
  if (filePath.endsWith('.dart')) {
    let content = fs.readFileSync(filePath, 'utf8');
    let original = content;
    
    // Replace Icons.x with Iconsax.y
    content = content.replace(/Icons\.([a-zA-Z_0-9]+)/g, (match, iconName) => {
      const mapped = iconMap[iconName];
      if (mapped) {
        return `Iconsax.${mapped}`;
      } else {
        // Fallback: try to guess or use the same
        console.warn(`No mapping found for Icons.${iconName} in ${filePath}`);
        // Let's default to mapping it to exactly what it was but under Iconsax if it exists, or just use a generic one like document
        // We will just map it to the closest approximation
        return `Iconsax.${iconName}`;
      }
    });

    if (content !== original) {
      // Ensure the Iconsax import exists
      if (!content.includes('package:iconsax/iconsax.dart')) {
        content = `import 'package:iconsax/iconsax.dart';\n` + content;
      }
      fs.writeFileSync(filePath, content);
      changedFilesCount++;
    }
  }
});

console.log(`Replaced icons in ${changedFilesCount} files.`);
