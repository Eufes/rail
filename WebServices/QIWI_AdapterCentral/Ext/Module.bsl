﻿
Функция CheckConnect()
	
	Возврат "Успешно " + ТекущаяДатаСеанса();
	
КонецФункции

// Общая функция обращения к подсистеме адаптера
//
// Параметры:
//  MsgType			 - Строка - Мнемокод для опредеелния типа входящего сообщения
//  MsgID			 - Строка - Идентификатор входящего сообщения (исходящего от внешней системы)
//  MsgBody			 - Произвольный - Данные от внешней системы
//  ExternalSystemID - Строка - Используется для быстрого определения соответствующей внешней системы в текущей базе
//  IntegrationProcessID - Строка - Идентификатор интеграционного процесса 
//  									справочника EUF_ПроводникИнтеграционныеПроцессы 
//  BodyType		 - Строка - Тип тела запроса (по умолчанию - строка). Используется для определения типа содержимого тела (текст или двоичные данные)
//
// Возвращаемое значение:
//  Строка, Структура - Данные в формате обмена (в коллекции или непосредственно строкой)
//
Функция Interaction(MsgType, MsgID, MsgBody, ExternalSystemID, IntegrationProcessID = "", BodyType = "")
			
	Попытка 
		Результат = EUF_ПроводникОбмен.ОбработатьВходящийЗапрос(MsgType, MsgID, MsgBody,
												ExternalSystemID, IntegrationProcessID, BodyType);
	Исключение
		ИнформацияПоОшибке = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		EUF_ПроводникВызовСервера.ВыполнитьЛогирование("Ошибка получения данных внешней системой "
										+ ExternalSystemID, УровеньЖурналаРегистрации.Ошибка,
										ИнформацияПоОшибке, , Истина); 
		Результат = ИнформацияПоОшибке;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции
