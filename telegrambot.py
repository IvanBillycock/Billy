import telebot
import os

def login_check(userid):
    with open('./ID.conf') as file:
        id_list = file.read()
        string_id = str(userid)
        if string_id in id_list:
            return True
        else:
            return False

bot = telebot.TeleBot('1**********0')

@bot.message_handler(content_types=['text'])
def get_text_messages(message):
    username = message.from_user.username
    first_name = message.from_user.first_name
    last_name = message.from_user.last_name
    id = message.from_user.id
    if message.text == 'ping' or message.text == 'Ping':
        pid = os.getpid()
        uptime = os.popen(f'ps -o etime= -p {pid}').read()
        bot.send_message(message.from_user.id, f'Server PID: {pid} \nUptime: {uptime}')
    elif message.text == 'id' or message.text == 'ID':
        bot.send_message(message.from_user.id, f'Nickname: {username} \nFirst Name: {first_name} \nLast Name: {last_name} \nID: {id}')
    elif message.text == "access":
        if login_check(id):
            bot.send_message(message.from_user.id, "works")
        else:
            bot.send_message(message.from_user.id, "works, but nothing")
    else:
        bot.send_message(message.from_user.id, "Sorry! I don't know all words in the world =(")

bot.polling()
