
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	    	
	УстановитьПараметрыДинамическихСписков();
	
	СоответствиеВкладокИФорматаВР = Новый Соответствие;
	СоответствиеВкладокИФорматаВР.Вставить(Перечисления.MultiPort_ИнтерфейсыТранспорта.WebService,
											"НастройкиПодключенийWS");
	СоответствиеВкладокИФорматаВР.Вставить(Перечисления.MultiPort_ИнтерфейсыТранспорта.HttpService,
											"НастройкиПодключенийHTTP");
	СоответствиеВкладокИФорматаВР.Вставить(Перечисления.MultiPort_ИнтерфейсыТранспорта.COM,
											"НастройкиПодключенияCOM");
	СоответствиеВкладокИФорматаВР.Вставить(Перечисления.MultiPort_ИнтерфейсыТранспорта.ExternalSystem,
											"НастройкиПодключенийПоСтроке");											
	СоответствиеВкладокИФормата	= Новый ФиксированноеСоответствие(СоответствиеВкладокИФорматаВР);									
											
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
	ОтметитьИспользуемыйФормат();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
		
	ПаролиФормы = "WSПароль,WSПарольОпределения,HTTPПароль,COMПароль,ExtSysПароль";	
	ПрочитатьПаролиИзХранилища(ПаролиФормы, ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.MultiPort_ПодключенияКВнешнимСистемам.ИдентификаторПодключенияУникален(ТекущийОбъект, Отказ);
	Если Отказ Тогда
		Возврат;			
	КонецЕсли;	
	
	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПроверкаВыполнена", Истина);	
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если WSПарольИзменен Тогда
		MultiPort_ШлюзБСПСервер.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, WSПароль, "WSПароль")
	КонецЕсли;
	
	Если WSПарольОпределенияИзменен Тогда
		MultiPort_ШлюзБСПСервер.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, WSПароль, "WSПарольОпределения")
	КонецЕсли;
	
	Если HTTPПарольИзменен Тогда
		MultiPort_ШлюзБСПСервер.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, HTTPПароль, "HTTPПароль")
	КонецЕсли;
	
	Если COMПарольИзменен Тогда
		MultiPort_ШлюзБСПСервер.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, COMПароль, "COMПароль")
	КонецЕсли;
	
	Если ExtSysПарольИзменен Тогда
		MultiPort_ШлюзБСПСервер.ЗаписатьДанныеВБезопасноеХранилище(ТекущийОбъект.Ссылка, ExtSysПароль, "ExtSysПароль")
	КонецЕсли;	
	
	УстановитьПараметрыДинамическихСписков();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнтерфейсТранспортаПоУмолчаниюПриИзменении(Элемент)
	ОтметитьИспользуемыйФормат();
КонецПроцедуры

&НаКлиенте
Процедура WSИмяСервисаПриИзменении(Элемент)
	Если Не ЗаполнятьДругиеПараметрыВручную Тогда
		Объект.WSИмяТочкиПодключения = Объект.WSИмяСервиса + "Soap"; 
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура WSПользовательПроксиПриИзменении(Элемент)
	Если Не ЗаполнятьДругиеПараметрыВручную Тогда
		Объект.WSПользовательОпределения = Объект.WSПользовательПрокси; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура WSПарольПриИзменении(Элемент)
	
	WSПарольИзменен = Истина;
	Если Не ЗаполнятьДругиеПараметрыВручную Тогда
		WSПарольОпределения = WSПароль;
		WSПарольОпределенияИзменен = Истина;
	КонецЕсли;
	
	ПарольПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура WSПарольРегулирование(Элемент, Направление, СтандартнаяОбработка)
	ПарольПриИзменении(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура WSПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
			
	ПолеПароляНачалоВыбора(Элемент, WSПароль, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура WSПарольОпределенияПриИзменении(Элемент)
	
	WSПарольОпределенияИзменен = Истина;
	ПарольПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура WSАутентификацияОСПриИзменении(Элемент)
	Если Не ЗаполнятьДругиеПараметрыВручную Тогда
		Объект.WSАутентификацияОСОпределения = Объект.WSАутентификацияОС;		
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура HTTPПарольПриИзменении(Элемент)
	
	HTTPПарольИзменен = Истина;
	ПарольПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура HTTPПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеПароляНачалоВыбора(Элемент, HTTPПароль, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура COMФайловаяБазаКорреспондентПриИзменении(Элемент)
	
	ВариантРаботыИнформационнойБазыПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантРаботыИнформационнойБазыПриИзменении()
	
	Если Объект.COMФайловаяБазаКорреспондент Тогда
		ТекущаяСтраница = Элементы.ФайловыйВариант;
	Иначе
		ТекущаяСтраница = Элементы.КлиентСерверныйВариант;
	КонецЕсли;	
	
	Элементы.ВариантыCOM.ТекущаяСтраница = ТекущаяСтраница;
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогИнформационнойБазыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Диалог.Заголовок = "Выберите каталог базы";
	Диалог.МножественныйВыбор = Ложь;
	ДополнительныеПараметры = Новый Структура("Диалог", Диалог);
	ОповещениеВыбора = Новый ОписаниеОповещения("COMКаталогНачалоВыбораЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОповещениеВыбора); 
	
КонецПроцедуры

&НаКлиенте
Процедура COMКаталогНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;	
	Объект.COMКаталогИнформационнойБазы = Диалог.Каталог;

КонецПроцедуры

&НаКлиенте
Процедура COMПарольПриИзменении(Элемент)
	
	COMПарольИзменен = Истина;
	ПарольПриИзменении(Элемент);
	
КонецПроцедуры 

&НаКлиенте
Процедура COMПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеПароляНачалоВыбора(Элемент, COMПароль, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ExtSysПарольПриИзменении(Элемент)
	
	ExtSysПарольИзменен = Истина;	
	ПарольПриИзменении(Элемент);

КонецПроцедуры 

&НаКлиенте
Процедура ExtSysПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПолеПароляНачалоВыбора(Элемент, ExtSysПароль, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьШаблонExtSys(Команда)
	
	Объект.ExtSysСтрокаПодключения = "Provider=OraOLEDB.Oracle;	
	|Data Source=TestDataSource;
	|DSN=Data_dsn;
	|User ID=&USER;Password=&PASSWORD;";
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыДинамическихСписков();
	
	ПараметрТекущиеНастройки = ДСИспользованиеТекущейНастройки.Параметры.Элементы.Найти("ПараметрыПодключения");
	ПараметрТекущиеНастройки.Использование = Истина;
	ПараметрТекущиеНастройки.Значение = Объект.Ссылка;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьДругиеПараметрыВручнуюПриИзменении(Элемент)
	
	Элементы.WSИмяТочкиПодключения.Доступность = ЗаполнятьДругиеПараметрыВручную;
	Элементы.WSПользовательОпределения.Доступность = ЗаполнятьДругиеПараметрыВручную;
	Элементы.WSПарольОпределения.Доступность = ЗаполнятьДругиеПараметрыВручную;
	Элементы.WSАутентификацияОСОпределения.Доступность = ЗаполнятьДругиеПараметрыВручную;	
	
КонецПроцедуры  

&НаКлиенте
Процедура ДС_ИспользованиеТекущейНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, ВыбраннаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПаролиИзХранилища(ПаролиФормы, ТекущийОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	Пароли = MultiPort_ШлюзБСПСервер.ПрочитатьДанныеИзБезопасногоХранилища(ТекущийОбъект, ПаролиФормы);
	УстановитьПривилегированныйРежим(Ложь);
	
	ОдинПароль = ?(ТипЗнч(Пароли) = Тип("Структура"), Ложь, Истина);
		
	МассивПаролей = СтрРазделить(ПаролиФормы, ",", Ложь);
	Для Каждого ПарольФормы Из МассивПаролей Цикл
		Если ОдинПароль Тогда
			ЭтотОбъект[ПарольФормы] = Пароли;
			Прервать;
		Иначе	
			ЭтотОбъект[ПарольФормы] = ?(ЗначениеЗаполнено(Пароли[ПарольФормы]), Пароли[ПарольФормы], "");
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПароляНачалоВыбора(Элемент, Реквизит, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	Реквизит = Элемент.ТекстРедактирования;
	Элемент.РежимПароля = Не Элемент.РежимПароля;
	Если Элемент.РежимПароля Тогда
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.MultiPort_ВводимыеСимволыСкрыты;
	Иначе
		Элемент.КартинкаКнопкиВыбора = БиблиотекаКартинок.MultiPort_ВводимыеСимволыВидны;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Элемент.КнопкаВыбора = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеWS(Результат, ДополнительныеПараметры) Экспорт
		
	ОчиститьСообщения();		
	ИнтерфейсТранспорта = ПредопределенноеЗначение("Перечисление.MultiPort_ИнтерфейсыТранспорта.WebService");
	ПроверитьПодключениеНаСервере(ИнтерфейсТранспорта);
			
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеHTTP(Команда)
	
	ОчиститьСообщения();		
	ИнтерфейсТранспорта = ПредопределенноеЗначение("Перечисление.MultiPort_ИнтерфейсыТранспорта.HttpService");
	ПроверитьПодключениеНаСервере(ИнтерфейсТранспорта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеCOM(Команда)
	
	ОчиститьСообщения();
	ИнтерфейсТранспорта = ПредопределенноеЗначение("Перечисление.MultiPort_ИнтерфейсыТранспорта.COM");
	ПроверитьПодключениеНаСервере(ИнтерфейсТранспорта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеExtSys(Команда)
	ОчиститьСообщения();
	ИнтерфейсТранспорта = ПредопределенноеЗначение("Перечисление.MultiPort_ИнтерфейсыТранспорта.ExternalSystem");
	ПроверитьПодключениеНаСервере(ИнтерфейсТранспорта);
КонецПроцедуры

&НаСервере
Процедура ПроверитьПодключениеНаСервере(ИнтерфейсТранспорта)
	
	СтруктураПараметров = Новый Структура;	
	СтруктураПараметров.Вставить("ПсевдоПодключение", 	Объект.ПсевдоПодключение);
	СтруктураПараметров.Вставить("ИнтерфейсТранспорта", ИнтерфейсТранспорта); 
	
	ПарольИзменен = Ложь;
	
	Если ИнтерфейсТранспорта = Перечисления.MultiPort_ИнтерфейсыТранспорта.WebService Тогда
		
		ПаролиДляПолучения = "WSПароль,WSПарольОпределения";
		ПарольИзменен = WSПарольИзменен;
		
		СтруктураПараметров.Вставить("WSПароль", WSПароль);
		СтруктураПараметров.Вставить("WSСсылкаWSDL", Объект.WSСсылкаWSDL);
		СтруктураПараметров.Вставить("WSПользовательОпределения", Объект.WSПользовательОпределения);
		СтруктураПараметров.Вставить("WSПарольОпределения", WSПарольОпределения);
		СтруктураПараметров.Вставить("WSАутентификацияОСОпределения", Объект.WSАутентификацияОСОпределения);
		СтруктураПараметров.Вставить("WSURIПространстваИменСервиса", Объект.WSURIПространстваИменСервиса);
		СтруктураПараметров.Вставить("WSИмяСервиса", Объект.WSИмяСервиса);
		СтруктураПараметров.Вставить("WSИмяТочкиПодключения", Объект.WSИмяТочкиПодключения);
		СтруктураПараметров.Вставить("WSПользовательПрокси", Объект.WSПользовательПрокси);		
		СтруктураПараметров.Вставить("WSАутентификацияОС", Объект.WSАутентификацияОС);
		СтруктураПараметров.Вставить("WSТаймаут", Объект.WSТаймаут);
		
	ИначеЕсли ИнтерфейсТранспорта = Перечисления.MultiPort_ИнтерфейсыТранспорта.HttpService Тогда
		
		ПаролиДляПолучения = "HTTPПароль";
		ПарольИзменен = HTTPПарольИзменен;
		
		СтруктураПараметров.Вставить("HTTPПароль", HTTPПароль);
		СтруктураПараметров.Вставить("HTTPАдресСервиса", Объект.HTTPАдресСервиса);
		СтруктураПараметров.Вставить("HTTPПользователь", Объект.HTTPПользователь);
		СтруктураПараметров.Вставить("HTTPРесурсНаСервере", Объект.HTTPРесурсНаСервере);
		СтруктураПараметров.Вставить("HTTPЗащищенноеСоединение", Объект.HTTPЗащищенноеСоединение);
		СтруктураПараметров.Вставить("HTTPТаймаут", Объект.HTTPТаймаут);
		СтруктураПараметров.Вставить("HTTPАутентификацияОС", Объект.HTTPАутентификацияОС);
		СтруктураПараметров.Вставить("HTTPПорт", Объект.HTTPПорт);
		СтруктураПараметров.Вставить("HTTPРесурсПроверкиСоединения", Объект.HTTPРесурсПроверкиСоединения);
		
	ИначеЕсли ИнтерфейсТранспорта = Перечисления.MultiPort_ИнтерфейсыТранспорта.COM Тогда
		
		ПаролиДляПолучения = "COMПароль";
		ПарольИзменен = COMПарольИзменен;
		
		СтруктураПараметров.Вставить("COMПароль", COMПароль);
		СтруктураПараметров.Вставить("COMФайловаяБазаКорреспондент", Объект.COMФайловаяБазаКорреспондент);
		СтруктураПараметров.Вставить("COMИмяПользователя", Объект.COMИмяПользователя);		
		СтруктураПараметров.Вставить("COMАутентификацияОперационнойСистемы", Объект.COMАутентификацияОперационнойСистемы);
		СтруктураПараметров.Вставить("COMИмяСервера1СПредприятия", Объект.COMИмяСервера1СПредприятия);
		СтруктураПараметров.Вставить("COMИмяБазыНаСервере1СПредприятия", Объект.COMИмяБазыНаСервере1СПредприятия);
		СтруктураПараметров.Вставить("COMКаталогИнформационнойБазы", Объект.COMКаталогИнформационнойБазы);
		
	ИначеЕсли ИнтерфейсТранспорта = Перечисления.MultiPort_ИнтерфейсыТранспорта.ExternalSystem Тогда
		
		ПаролиДляПолучения = "ExtSysПароль";
		ПарольИзменен = ExtSysПарольИзменен;
		
		СтруктураПараметров.Вставить("ExtSysПароль", ExtSysПароль);
		СтруктураПараметров.Вставить("ExtSysСтрокаПодключения", Объект.ExtSysСтрокаПодключения);
		СтруктураПараметров.Вставить("ExtSysТаймаут", 0);
		СтруктураПараметров.Вставить("ExtSysИмяПриложенияCOM", Объект.ExtSysИмяПриложенияCOM);		
		СтруктураПараметров.Вставить("ExtSysИмяПользователя", Объект.ExtSysИмяПользователя);
		
	Иначе					
		ТекстИсключения = "Не удалось определить параметры подключения - не указан интерфейс транспорта ";
		MultiPort_ШлюзБСПКлиентСервер.СообщитьПользователю(ТекстИсключения);
        Возврат;
	КонецЕсли;
	
	Если Не ПарольИзменен И Не Параметры.Ключ.Пустая() Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароли = MultiPort_ШлюзБСПСервер.ПрочитатьДанныеИзБезопасногоХранилища(Объект.Ссылка, ПаролиДляПолучения);
		УстановитьПривилегированныйРежим(Ложь);
		
		ОдинПароль = ?(ТипЗнч(Пароли) = Тип("Структура"), Ложь, Истина);
		
		МассивПаролей = СтрРазделить(ПаролиДляПолучения, ",", Ложь);
		Для Каждого ПарольПараметров Из МассивПаролей Цикл
			Если ОдинПароль Тогда
				СтруктураПараметров[ПарольПараметров] = Пароли;
				Прервать;
			Иначе
				СтруктураПараметров[ПарольПараметров] = Пароли[ПарольПараметров];
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	Попытка 			
		Коннектор = MultiPort_Обмен.КоннекторКВнешейСистеме(СтруктураПараметров);
		Если Коннектор <> Неопределено Тогда
			Если СтруктураПараметров.Свойство("КодОтвета") Тогда
				MultiPort_ШлюзБСПКлиентСервер.СообщитьПользователю("Есть ограничения (см. код ответа)");
			Иначе	
				MultiPort_ШлюзБСПКлиентСервер.СообщитьПользователю("Успешно");
			КонецЕсли; 		
		КонецЕсли;
	Исключение
		ТекстИсключения = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		MultiPort_ШлюзБСПКлиентСервер.СообщитьПользователю(ТекстИсключения);
        Возврат;
	КонецПопытки;		
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь; 
	ТекстВопроса = "Будет сгенерирован идентификатор в транслите от текущего наименования.
	| Если он был сгенерирован ранее, то изменять его рекомендуется только при уверенности корректного обращения к нему.
	| Контроль уникальности в пределах базы определяется во время записи. ПРОДОЛЖИТЬ?";
	ОписаниеОповещения = Новый ОписаниеОповещения("ИдентификаторНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторНачалоВыбораЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;	
	
	СтрокаЛатиницей = MultiPort_ШлюзБСПКлиентСервер.СтрокаЛатиницей(Объект.Наименование);	
	СтрокаЛатиницей = СокрЛП(СтрокаЛатиницей);
	СтрокаЛатиницей = СтрЗаменить(СтрокаЛатиницей, " ", "_");
	Объект.ИдентификаторПодключения = НРег(СтрокаЛатиницей);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьИспользуемыйФормат()
	
	Для Каждого КлючИЗначение Из СоответствиеВкладокИФормата Цикл
		Элементы[КлючИЗначение.Значение].Картинка = Новый Картинка;
	КонецЦикла;
		
	ИмяВкладки = СоответствиеВкладокИФормата.Получить(Объект.ИнтерфейсТранспортаПоУмолчанию);
	Если ИмяВкладки <> Неопределено Тогда			
		ТекущаяСтраница = Элементы[ИмяВкладки];
		ТекущаяСтраница.Картинка = БиблиотекаКартинок.ОформлениеФлагКрасный; 
		Элементы.СтраницыВидовТранспорта.ТекущаяСтраница = ТекущаяСтраница;
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти