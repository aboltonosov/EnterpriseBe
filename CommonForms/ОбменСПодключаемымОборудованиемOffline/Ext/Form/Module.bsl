﻿
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Для Каждого Устройство Из Устройства Цикл
		
		УстойствоОбъект = Устройство.ПолучитьОбъект();
		УстойствоОбъект.ПравилоОбмена = ПравилоОбмена;
		УстойствоОбъект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтчетОРозничныхПродажахПоКассе(КассаККМ, ДатаЗагрузки)
	
	Отчет = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОтчетОРозничныхПродажах.Ссылка КАК Отчет
	|ИЗ
	|	Документ.ОтчетОРозничныхПродажах КАК ОтчетОРозничныхПродажах
	|ГДЕ
	|	ОтчетОРозничныхПродажах.КассаККМ = &КассаККМ
	|	И ОтчетОРозничныхПродажах.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания");
	
	Запрос.УстановитьПараметр("КассаККМ", КассаККМ);
	Запрос.УстановитьПараметр("ДатаНачала",    ДатаЗагрузки - 5);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаЗагрузки + 5);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Отчет = Выборка.Отчет;
	КонецЕсли;
	
	Возврат Отчет;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
	
	Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
	
	Элементы.КассыККМКассыТоварыЗагрузитьОтчетОРозничныхПродажах.Доступность = ПравоДоступа("Добавление", Метаданные.Документы.ОтчетОРозничныхПродажах);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	СкладККМOffline = Настройки.Получить("СкладККМOffline");
	СкладВесы = Настройки.Получить("СкладВесы");
	
	ПравилоОбменаВесы = Настройки.Получить("ПравилоОбменаВесы");
	ПравилоОбменаККМOffline = Настройки.Получить("ПравилоОбменаККМOffline");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Ложь);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Ложь);
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененоРабочееМестоТекущегоСеанса" Тогда
		
		РабочееМесто = МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента();
		
		Весы.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		КассыККМ.Параметры.УстановитьЗначениеПараметра("ТекущееРабочееМесто", РабочееМесто);
		
	ИначеЕсли ИмяСобытия = "Запись_ПравилаОбменаСПодключаемымОборудованиемOffline"
		ИЛИ ИмяСобытия = "Запись_КодыТоваровПодключаемогоОборудования" Тогда
		
		Элементы.Весы.Обновить();
		Элементы.КассыККМ.Обновить();
		
	ИначеЕсли ИмяСобытия = "ВыполненОбменСПодключаемымОборудованиемOffline" Тогда
		
		Элементы.Весы.Обновить();
		Элементы.КассыККМ.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#Область ПроцедурыОбработчикиКоманд

&НаКлиенте
Процедура ВесыПосмотретьСписокТоваров(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПараметрыФормы = Новый Структура("Устройство, ПравилоОбмена", ТекущиеДанные.ПодключаемоеОборудование, ТекущиеДанные.ПравилоОбмена);
		ОткрытьФорму("РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline.Форма.СписокТоваров", ПараметрыФормы, УникальныйИдентификатор);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.Весы.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток"));
		ПравилоОбмена = Неопределено;

		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,,, Новый ОписаниеОповещения("ВесыНазначитьПравилоДляВыделенныхЗавершение", ЭтотОбъект, Новый Структура("Устройства", Устройства)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыНазначитьПравилоДляВыделенныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Устройства = ДополнительныеПараметры.Устройства;
    
    
    ПравилоОбмена = Результат;
    
    Если ЗначениеЗаполнено(ПравилоОбмена) Тогда
        НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена);
    КонецЕсли;
    
    Элементы.Весы.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыВыгрузить(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьТоварыВВесы(Неопределено, Устройства);

	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыОчистить(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ОчиститьТоварыВВесах(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыТоварыПерезагрузить(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьПолныйСписокТоваровВВесы(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыПосмотретьСписокТоваров(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПараметрыФормы = Новый Структура("Устройство, ПравилоОбмена", ТекущиеДанные.ПодключаемоеОборудование, ТекущиеДанные.ПравилоОбмена);
		ОткрытьФорму("РегистрСведений.КодыТоваровПодключаемогоОборудованияOffline.Форма.СписокТоваров", ПараметрыФормы, УникальныйИдентификатор);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенных(Команда)
	
	Устройства = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из Элементы.КассыККМ.ВыделенныеСтроки Цикл
		Устройства.Добавить(ВыделеннаяСтрока);
	КонецЦикла;
	
	Если Устройства.Количество() > 0 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТипПодключаемогоОборудования", ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ККМOffline"));
		ПравилоОбмена = Неопределено;

		ОткрытьФорму("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ФормаВыбора", ПараметрыОткрытия, УникальныйИдентификатор,,,, Новый ОписаниеОповещения("КассыНазначитьПравилоДляВыделенныхЗавершение", ЭтотОбъект, Новый Структура("Устройства", Устройства)), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыНазначитьПравилоДляВыделенныхЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Устройства = ДополнительныеПараметры.Устройства;
    
    
    ПравилоОбмена = Результат;
    
    Если ЗначениеЗаполнено(ПравилоОбмена) Тогда
        НазначитьПравилоДляВыделенныхУстройствНаСервере(Устройства, ПравилоОбмена);
    КонецЕсли;
    
    Элементы.КассыККМ.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыВыгрузить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьТоварыВККМOffline(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыОчистить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ОчиститьТоварыВККМOffline(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыПерезагрузить(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьПолныйСписокТоваровВККМOffline(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыТоварыЗагрузитьОтчетОРозничныхПродажах(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		Устройства = Новый Массив;
		Устройства.Добавить(ТекущиеДанные.ПодключаемоеОборудование);
		ПодключаемоеОборудованиеOfflineКлиент.ЗагрузитьОтчетОРозничныхПродажах(Неопределено, Устройства);
	
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВесыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.Весы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ПравилоОбмена);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КассыОткрытьПравилоОбмена(Команда)
	
	ТекущиеДанные = Элементы.КассыККМ.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.ПравилоОбмена) Тогда
		
		ПоказатьЗначение(Неопределено, ТекущиеДанные.ПравилоОбмена);
		
	Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическийОбмен(Команда)
	
	ПараметрыФормы = Новый Структура("РабочееМесто", РабочееМесто);
	ОткрытьФорму("ОбщаяФорма.АвтоматическийОбменСПодключаемымОборудованиемOffline", ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура СкладВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "Склад", СкладВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "ПравилоОбмена", ПравилоОбменаВесы, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаВесы));
	
КонецПроцедуры

&НаКлиенте
Процедура СкладККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "Склад", СкладККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(СкладККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ПравилоОбменаККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "ПравилоОбмена", ПравилоОбменаККМOffline, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(ПравилоОбменаККМOffline));
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеККМOfflineПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(КассыККМ, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеККМOffline = Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОборудованиеВесыПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Весы, "ПодключеноКТекущемуРабочемуМесту", Истина, ВидСравненияКомпоновкиДанных.Равно,, ВсеОборудованиеВесы = Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура КассыККМВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если Поле = Элементы.КассыККМДатаЗагрузки И ЗначениеЗаполнено(ТекущиеДанные.ДатаЗагрузки) Тогда
		СтандартнаяОбработка = Ложь;
		Отчет = ПолучитьОтчетОРозничныхПродажахПоКассе(ТекущиеДанные.КассаККМ, ТекущиеДанные.ДатаЗагрузки);
		
		Если ЗначениеЗаполнено(Отчет) Тогда
			ПоказатьЗначение(Неопределено, Отчет);
		Иначе
			ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Отчет о розничных продажах не найден.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
