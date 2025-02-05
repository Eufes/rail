#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ИдентификаторПодключенияУникален(Объект, Отказ) Экспорт
	
	ТекстСообщения = ""; 
	
	Если ЗначениеЗаполнено(Объект.ИдентификаторПодключения) Тогда
		// Уникальность проверяем только для заполненных
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПодключенияКвнешнимСистемам.Представление КАК Представление,
		|	ПодключенияКвнешнимСистемам.Код КАК Код
		|ИЗ
		|	Справочник.MultiPort_ПодключенияКВнешнимСистемам КАК ПодключенияКвнешнимСистемам
		|ГДЕ
		|	ПодключенияКвнешнимСистемам.ИдентификаторПодключения = &ИдентификаторПодключения
		|	И ПодключенияКвнешнимСистемам.Ссылка <> &Ссылка";
		Запрос.УстановитьПараметр("ИдентификаторПодключения", Объект.ИдентификаторПодключения);
		Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстСообщения = СтрШаблон("Процесс с таким идентификатором уже существует %1 %2",
			Выборка.Код, Выборка.Представление);
			Отказ = Истина;
			Возврат ТекстСообщения;		
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

// Возвращает ссылку на параметры подключения по идентификатору
//
// Параметры:
//  ИдентификаторПодключения - Строка - идентификатор подключения
// 
// Возвращаемое значение:
//  СправочникСсылка.MultiPort_ПодключенияКВнешнимСистемам, Неопределено - ссылка на элемент, если найден.
//
Функция ПолучитьПараметрыПодключенияПоИдентификатору(ИдентификаторПодключения) Экспорт
	
	Если Не ЗначениеЗаполнено(ИдентификаторПодключения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ИдентификаторПодключения) <> Тип("Строка") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПодключенияКВнешнимСистемам.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ПодключенияКВнешнимСистемам.ПометкаУдаления
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.MultiPort_ПодключенияКВнешнимСистемам КАК ПодключенияКВнешнимСистемам
	|ГДЕ
	|	ПодключенияКВнешнимСистемам.ИдентификаторПодключения = &ИдентификаторПодключения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	Запрос.УстановитьПараметр("ИдентификаторПодключения", ИдентификаторПодключения);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

#КонецЕсли