import requests
import json

def create_user_sync():
    # url1 = "http://localhost:8000/api/auth/register"
    # url2 = "http://localhost:8000/api/auth/login"
    url3 = "http://localhost:8000/api/orders/get_image/album_1.jpg"
    
    # Данные для отправки
    # user_data1 = {
    #         "login": "somebody",
    #         "password_primary": "Smi12341",
    #         "password_sustaining": "Smi12341"
    # }
    
    # user_data2 = {
    #         "login": "somebody",
    #         "password": "12341"
    # }
    
    # response1 = requests.post(
    #     url1,
    #     json=user_data1
    # )
    
    # response2 = requests.post(
    #     url2,
    #     json=user_data2
    # )
    
    response3 = requests.get(
        url3
    )
    
    # Проверяем статус
    # response1.raise_for_status()
    
    # # Получаем данные
    # created_user = response1.json()
    
    # print(f"Статус: {response1.status_code}")
    # print(f"Ответ: {json.dumps(created_user, indent=2, ensure_ascii=False)}")
    
    # # Проверяем статус
    # response2.raise_for_status()
    
    # # Получаем данные
    # created_user = response2.json()
    
    # print(f"Статус: {response2.status_code}")
    # print(f"Ответ: {json.dumps(created_user, indent=2, ensure_ascii=False)}")
    
    response3.raise_for_status()
    
    # Получаем данные
    created_user = response3.json()
    
    print(f"Статус: {response3.status_code}")
    print(f"Ответ: {json.dumps(created_user, indent=2, ensure_ascii=False)}")
    
create_user_sync()