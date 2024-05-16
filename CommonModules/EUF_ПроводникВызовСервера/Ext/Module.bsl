﻿
#Область Логирование //******************************************
 
// Запись логов событий в регистр и журнал регистрациии
//
// Параметры:
//  ИмяСобытия  - Строка - Классфикация события. Короткий текст.
//  Уровень  	- УровеньЖурналаРегистрации - Уровень важности событий журнала регистрации 
//  Информация 	- Строка - Информация о событии
//	ДанныеДляЖР	- Число, Строка, Дата, Булево, Неопределено, Null, Тип - Ссылка на связанные данные
//	ЗаписыватьВПротокол - Булево - Признак для записи в отдельный регистр
//	СсылкаНаСообщение 	- СправочникСсылка.EUF_ПроводникСообщенияИсходящие
//						- СправочникСсылка.EUF_ПроводникСообщенияВходящие - ссылка на сообщение
//
Процедура ВыполнитьЛогирование(Знач ИмяСобытия, Знач Уровень, Знач Информация, Знач ДанныеДляЖР = Неопределено,
					Знач ЗаписыватьВПротокол = Ложь, Знач СсылкаНаСообщение = Неопределено) Экспорт
					
	УстановитьПривилегированныйРежим(Истина);
	
	ТранзакцияАктивнаИБылиОшибки = ТранзакцияАктивна() И EUF_ПроводникОбщегоНазначения.ВТранзакцииПроисходилиОшибки();
	
	Если ТранзакцияАктивнаИБылиОшибки И EUF_ПроводникОбщегоНазначения.ЭтоОбъектСсылочногоТипа(ДанныеДляЖР) Тогда
		ДанныеДляЖРБезопасные = "" + ДанныеДляЖР.УникальныйИдентификатор();
	Иначе
		ДанныеДляЖРБезопасные = ДанныеДляЖР;
	КонецЕсли;	
		
	ЗаписьЖурналаРегистрации("EUF_Проводник. " + ИмяСобытия, Уровень, , ДанныеДляЖРБезопасные, Информация);
			
	Если ЗаписыватьВПротокол И Не ТранзакцияАктивнаИБылиОшибки Тогда
		
		Попытка
			МенеджерЗаписи = РегистрыСведений.EUF_ПроводникПротоколОбмена.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Сообщение = СсылкаНаСообщение;
			МенеджерЗаписи.Пользователь = EUF_ПроводникШлюзБСПСервер.АвторизованныйПользователь();
			Если Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
				УровеньСобытия = Перечисления.EUF_ПроводникУровниСобытийПротокола.Ошибка;
			Иначе
				УровеньСобытия = Перечисления.EUF_ПроводникУровниСобытийПротокола.Информация;
			КонецЕсли;
			МенеджерЗаписи.УровеньСобытия = УровеньСобытия;
			
			МенеджерЗаписи.ГодИМесяц = Формат(ТекущаяДатаСеанса(), "ДФ=yyyy_MM");			
			МенеджерЗаписи.ОписаниеСобытия = Информация;
			МенеджерЗаписи.ДатаСобытия = ТекущаяДатаСеанса();
			МенеджерЗаписи.УникальноеВремяСобытия = ТекущаяУниверсальнаяДатаВМиллисекундах();
			
			МенеджерЗаписи.Записать();
		Исключение
			ТекстОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации("EUF_ПроводникОшибкаЛогирования", УровеньЖурналаРегистрации.Ошибка, ,
										ДанныеДляЖР, ТекстОшибки);
		КонецПопытки;		
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры 

#КонецОбласти // Логирование

#Область Уведомления //******************************************

// Формирует параметры для отправки письма
//
// Параметры:
//  Адресаты - ТаблицаЗначений	- Получатели. Могут быть получены функцией ПолучитьАдресатовИнтеграционногоПроцесса()
// 
// Возвращаемое значение:
//  Структура - Параметры письма:
//  	* Кому - Массив из Строка  			 
//  	* Тема - Строка
//  	* ПолучателиСтрокой - Строка
//
Функция СформироватьПараметрыПисьма(Знач Адресаты) Экспорт
		
	ПараметрыПисьма = Новый Структура();
	
	Кому = Новый Массив;
	МассивАдресов = Новый Массив;
	Для Каждого ПочтовыйАдрес Из Адресаты Цикл
		Кому.Добавить(Новый Структура("Адрес, Представление", ПочтовыйАдрес.Адрес, ПочтовыйАдрес.Представление));
		МассивАдресов.Добавить(ПочтовыйАдрес.Адрес);
	КонецЦикла;
		
	ПараметрыПисьма.Вставить("Кому", Кому);
	ПараметрыПисьма.Вставить("Тема", "Ошибка синхронизации справочников контрагентов(договоров) ДО -> 1С");
	ПараметрыПисьма.Вставить("ПолучателиСтрокой", СтрСоединить(МассивАдресов));
	
	Возврат ПараметрыПисьма;
	
КонецФункции

#КонецОбласти // Уведомления

