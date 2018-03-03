﻿#Область ОписаниеПеременных

&НаСервере
Перем ТаблицаПодразделений;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ЗаполнитьСписокПодразделений();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	СохраненныеНастройки = Настройки.Получить("СписокПодразделений");
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВосстановитьНастройкиСпискаПодразделений(СохраненныеНастройки.Строки);
	
	Настройки.Удалить("СписокПодразделений");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ТаблицаПодразделений.Подразделение КАК Справочник.СтруктураПредприятия) КАК Подразделение,
	|	ВЫРАЗИТЬ(ТаблицаПодразделений.ЦеховаяКладовая КАК Справочник.Склады) КАК ЦеховаяКладовая
	|ПОМЕСТИТЬ ТаблицаПодразделений
	|ИЗ
	|	&ТаблицаПодразделений КАК ТаблицаПодразделений
	|ГДЕ
	|	ТаблицаПодразделений.ЦеховаяКладовая <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаПодразделений.Подразделение.Наименование КАК ПодразделениеНаименование,
	|	СпрСклад.Ссылка КАК Склад,
	|	СпрСклад.Наименование КАК СкладНаименование,
	|	СпрСклад.ИспользоватьОрдернуюСхемуПриПоступлении
	|		ИЛИ СпрСклад.ИспользоватьОрдернуюСхемуПриОтгрузке КАК ЕстьОрдернаяСхема,
	|	МАКСИМУМ(НЕ ТаблицаДругихПодразделений.Подразделение ЕСТЬ NULL ) КАК ОднаКладоваяРазныхПодразделений
	|ИЗ
	|	ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК СпрСклад
	|		ПО (СпрСклад.Ссылка = ТаблицаПодразделений.ЦеховаяКладовая)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаДругихПодразделений
	|		ПО (ТаблицаДругихПодразделений.ЦеховаяКладовая = ТаблицаПодразделений.ЦеховаяКладовая)
	|			И (ТаблицаДругихПодразделений.Подразделение <> ТаблицаПодразделений.Подразделение)
	|ГДЕ
	|	(СпрСклад.ИспользоватьОрдернуюСхемуПриПоступлении
	|			ИЛИ СпрСклад.ИспользоватьОрдернуюСхемуПриОтгрузке
	|			ИЛИ НЕ ТаблицаДругихПодразделений.Подразделение ЕСТЬ NULL )
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПодразделений.Подразделение,
	|	СпрСклад.Ссылка,
	|	ТаблицаПодразделений.Подразделение.Наименование,
	|	СпрСклад.Наименование,
	|	СпрСклад.ИспользоватьОрдернуюСхемуПриПоступлении
	|		ИЛИ СпрСклад.ИспользоватьОрдернуюСхемуПриОтгрузке";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаПодразделений", ТаблицаПодразделений);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЕстьОрдернаяСхема Тогда
			ТекстОшибки = НСтр("ru = 'Склад ""%1"" не может использоваться как цеховая кладовая для подразделения ""%2"", т.к. на складе используется ордерная схема.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.СкладНаименование, Выборка.ПодразделениеНаименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Склад,,, Отказ); 
		КонецЕсли; 
		
		Если Выборка.ОднаКладоваяРазныхПодразделений Тогда
			ТекстОшибки = НСтр("ru = 'Цеховая кладовая ""%1"", указанная для подразделения ""%2"", не может использоваться для других подразделений. У каждого подразделения должна быть своя цеховая кладовая.'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, Выборка.СкладНаименование, Выборка.ПодразделениеНаименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Склад,,, Отказ); 
		КонецЕсли; 
	
	КонецЦикла;
	
	Если Отказ Тогда
		ЕстьОшибки = Истина;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НастройкиВосстановлены Тогда
		ПоказатьОповещениеПользователя(,, НСтр("ru = 'Восстановлены ранее введенные значения.
                                                |Для использования значений по умолчанию выполните команду ""Обновить"".'"));
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПодразделенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СписокПодразделений.ТекущиеДанные;
	
	Если Поле = Элементы.СписокПодразделенийПодразделение Тогда
		ПоказатьЗначение(, ТекущиеДанные.Подразделение);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоУмолчанию(Команда)
	
	ЗаполнитьСписокПодразделений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьДействия(Команда)
	
	ОчиститьСообщения();
	
	ЕстьОшибки = Ложь;
	
	ВыполнитьДействияНаСервере();
	
	Если ЕстьОшибки Тогда
		
		ПоказатьОповещениеПользователя(
			,, 
			НСтр("ru = 'Создание цеховых кладовых завершено с ошибками (см. журнал регистрации)'"),
			БиблиотекаКартинок.Внимание48);
		
	Иначе
		
		ПоказатьОповещениеПользователя(
			,, 
			НСтр("ru = 'Создание цеховых кладовых завершено'"), 
			БиблиотекаКартинок.Успешно32);
			
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСтатьюИТС(Команда)
	
	УправлениеПроизводствомКлиент.ОткрытьСтатью5ШаговКПроизводству22();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийЦеховаяКладовая.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.ЦеховаяКладовая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.СоздатьКладовую");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<создание кладовой не требуется>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийЦеховаяКладовая.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.ЦеховаяКладовая");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.СоздатьКладовую");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<будет создана новая кладовая>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстИнформационнойНадписи);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийЦеховаяКладовая.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.ПроизводственноеПодразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<только для производственного подразделения>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийСоздатьКладовую.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийИсточникОбеспечения.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийСрокИсполненияЗаказа.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийОбеспечиваемыйПериод.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийДлительностьПеремещения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.ПроизводственноеПодразделение");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
	//
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийИсточникОбеспечения.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийСрокИсполненияЗаказа.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийОбеспечиваемыйПериод.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПодразделенийДлительностьПеремещения.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПодразделений.СоздатьКладовую");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПодразделений()

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	СтруктураПредприятия.Ссылка КАК Подразделение,
	|	СтруктураПредприятия.ПроизводственноеПодразделение КАК ПроизводственноеПодразделение,
	|	МАКСИМУМ(ЦеховыеКладовые.Ссылка) КАК ЦеховаяКладовая,
	|	НастройкаПередачи.Склад КАК ИсточникОбеспечения,
	|	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
	|				КОГДА НЕ НастройкаПередачиПоддержаниеЗапасов.Подразделение ЕСТЬ NULL 
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ), ЛОЖЬ) КАК ПоддерживаютсяЗапасы,
	|	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
	|				КОГДА НЕ НастройкаПередачиПоддержаниеЗапасов.Подразделение ЕСТЬ NULL 
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ), ЛОЖЬ) КАК СоздатьКладовую,
	|	1 КАК ДлительностьПеремещения,
	|	1 КАК СрокИсполненияЗаказа,
	|	0 КАК ОбеспечиваемыйПериод
	|ИЗ
	|	Справочник.СтруктураПредприятия КАК СтруктураПредприятия
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Склады КАК ЦеховыеКладовые
	|		ПО (ЦеховыеКладовые.Подразделение = СтруктураПредприятия.Ссылка)
	|			И (ЦеховыеКладовые.ЦеховаяКладовая)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачи
	|		ПО (НастройкаПередачи.Подразделение = СтруктураПредприятия.Ссылка)
	|			И (НастройкаПередачи.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
	|			И (НастройкаПередачи.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачиПоддержаниеЗапасов
	|		ПО (НастройкаПередачиПоддержаниеЗапасов.Подразделение = СтруктураПредприятия.Ссылка)
	|			И (НастройкаПередачиПоддержаниеЗапасов.ОснованиеДляПолучения = ЗНАЧЕНИЕ(Перечисление.ОснованияДляПолученияМатериаловВПроизводстве.ПоЗаказуНаВнутреннееПотребление))
	|ГДЕ
	|	НЕ СтруктураПредприятия.ПометкаУдаления
	|
	|СГРУППИРОВАТЬ ПО
	|	СтруктураПредприятия.Ссылка,
	|	НастройкаПередачи.Склад,
	|	СтруктураПредприятия.ПроизводственноеПодразделение
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтруктураПредприятия.Ссылка ИЕРАРХИЯ,
	|	СтруктураПредприятия.Наименование";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Результат = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	УдалитьНеПроизводственныеПодразделения(Результат.Строки);

	ЗначениеВРеквизитФормы(Результат, "СписокПодразделений");

КонецПроцедуры

&НаСервере
Функция УдалитьНеПроизводственныеПодразделения(СписокСтрок)

	СтрокКУдалению = Новый Массив;
	
	ЕстьПроизводственныеПодразделения = Ложь;
	
	Для каждого ЭлементДерева Из СписокСтрок Цикл
		Если НЕ ЭлементДерева.ПроизводственноеПодразделение
			И НЕ УдалитьНеПроизводственныеПодразделения(ЭлементДерева.Строки) Тогда
			СтрокКУдалению.Добавить(ЭлементДерева);
		Иначе
			ЕстьПроизводственныеПодразделения = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ЭлементДерева Из СтрокКУдалению Цикл
		СписокСтрок.Удалить(ЭлементДерева);
	КонецЦикла; 

	Возврат ЕстьПроизводственныеПодразделения;
	
КонецФункции

&НаСервере
Процедура ВыполнитьДействияНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЗаполнитьТаблицуПодразделений();
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьЦеховыеКладовые();
	ЗаполнитьСхемыОбеспеченияПроизводства();
	НастроитьПоддержаниеЗапасовВКладовых();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПодразделений()
	
	ТаблицаПодразделений = Новый ТаблицаЗначений;
	Для Каждого Колонка Из РеквизитФормыВЗначение("СписокПодразделений").Колонки Цикл
		ТаблицаПодразделений.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	ПеренестиВТаблицуПодразделенийДанныеСтрокДерева(СписокПодразделений.ПолучитьЭлементы());
	
КонецПроцедуры

Процедура ПеренестиВТаблицуПодразделенийДанныеСтрокДерева(СтрокиДерева)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		Если СтрокаДерева.ПроизводственноеПодразделение Тогда
			ЗаполнитьЗначенияСвойств(ТаблицаПодразделений.Добавить(), СтрокаДерева);
		КонецЕсли;
		ПеренестиВТаблицуПодразделенийДанныеСтрокДерева(СтрокаДерева.ПолучитьЭлементы());
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СоздатьЦеховыеКладовые()

	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ТипСклада", Перечисления.ТипыСкладов.ОптовыйСклад);
			
	Для каждого СтрокаПодразделение Из ТаблицаПодразделений Цикл
		
		Если ЗначениеЗаполнено(СтрокаПодразделение.ЦеховаяКладовая) Тогда
			
			СпрСклад = СтрокаПодразделение.ЦеховаяКладовая.ПолучитьОбъект();
			
			Если СпрСклад.ЦеховаяКладовая 
				ИЛИ СпрСклад.ИспользоватьОрдернуюСхемуПриПоступлении
				ИЛИ СпрСклад.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
				Продолжить;
			КонецЕсли;
			
			СпрСклад.ЦеховаяКладовая = Истина;
			СпрСклад.Записать();
			
		ИначеЕсли СтрокаПодразделение.СоздатьКладовую Тогда
			
			СпрСклад = Справочники.Склады.СоздатьЭлемент();
			
			СпрСклад.Заполнить(ЗначенияЗаполнения);
			СпрСклад.Наименование = СтрШаблон(НСтр("ru = 'Цеховая кладовая (%1)'"), Строка(СтрокаПодразделение.Подразделение));
			СпрСклад.ЦеховаяКладовая = Истина;
			СпрСклад.Подразделение = СтрокаПодразделение.Подразделение;

			Если НЕ СпрСклад.ПроверитьЗаполнение() Тогда
				ТекстОшибки = НСтр("ru = 'При проверке заполнения новой цеховой кладовой для подразделения ""%1"" возникли ошибки. Обратитесь к администратору.'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, СтрокаПодразделение.Подразделение);
				ДобавитьОшибку(ТекстОшибки);
				Продолжить;
			КонецЕсли;
			
			СпрСклад.ДополнительныеСвойства.Вставить("ПропуститьОбновлениеФлагаКонтроляОперативныхОстатков");
			СпрСклад.Записать();
			
			ЗаполнитьПолитикиУчетаСерий(СпрСклад.Ссылка, СтрокаПодразделение.Подразделение);
			
			СтрокаПодразделение.ЦеховаяКладовая = СпрСклад.Ссылка;
			
			СтрокаСпискаПодразделений = НайтиСтрокуВСпискеРекурсивно(
											СтрокаПодразделение.Подразделение, 
											СписокПодразделений.ПолучитьЭлементы());
											
			СтрокаСпискаПодразделений.ЦеховаяКладовая = СтрокаПодразделение.ЦеховаяКладовая;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолитикиУчетаСерий(ЦеховаяКладовая, Подразделение)

	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыНоменклатурыПолитикиУчетаСерий.Ссылка
	|ИЗ
	|	Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ВидыНоменклатурыПолитикиУчетаСерий
	|ГДЕ
	|	ВидыНоменклатурыПолитикиУчетаСерий.Склад = &Подразделение";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СпрВидНоменклатуры = Выборка.Ссылка.ПолучитьОбъект();
		
		СтруктураПоиска = Новый Структура("Склад", Подразделение);
  		СписокСтрок = СпрВидНоменклатуры.ПолитикиУчетаСерий.НайтиСтроки(СтруктураПоиска);
		Для каждого СтрокаПолитикаПодразделения Из СписокСтрок Цикл
			
			Если СпрВидНоменклатуры.ВариантНастройкиСерийДляСкладов = Перечисления.ВариантыНастроекСерий.ЕдинаяНастройка 
				И СпрВидНоменклатуры.ПолитикаУчетаСерийДляСкладов <> СтрокаПолитикаПодразделения.ПолитикаУчетаСерий Тогда
				ТекстОшибки = НСтр("ru = 'Не удалось перенести политику учета серий для цеховой кладовой ""%1"" и для вида номенклатуры ""%2"", по причине:
							|Для вида номенклатуры настроено использование одной политики учета серий для всех складов (%3), которая отличается от политики учета серий в подразделении (%4).'");
				ТекстОшибки = СтрШаблон(ТекстОшибки, 
										ЦеховаяКладовая, 
										СпрВидНоменклатуры.Наименование, 
										СпрВидНоменклатуры.ПолитикаУчетаСерийДляСкладов, 
										СтрокаПолитикаПодразделения.ПолитикаУчетаСерий);
										
				ДобавитьОшибку(ТекстОшибки, СпрВидНоменклатуры.Ссылка);
				Продолжить;
			КонецЕсли;
			
			СтрокаПолитикаЦеховой = СпрВидНоменклатуры.ПолитикиУчетаСерий.Добавить();
			СтрокаПолитикаЦеховой.Склад = ЦеховаяКладовая;
			СтрокаПолитикаЦеховой.ПолитикаУчетаСерий = СтрокаПолитикаПодразделения.ПолитикаУчетаСерий;
		КонецЦикла;
		
		СпрВидНоменклатуры.Записать();
	
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСхемыОбеспеченияПроизводства()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПодразделений.Подразделение,
	|	ТаблицаПодразделений.ИсточникОбеспечения
	|ПОМЕСТИТЬ ТаблицаПодразделений
	|ИЗ
	|	&ТаблицаПодразделений КАК ТаблицаПодразделений
	|ГДЕ
	|	ТаблицаПодразделений.ИсточникОбеспечения <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаПодразделений.Подразделение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Подразделение КАК Подразделение,
	|	Таблица.Номенклатура.СхемаОбеспечения КАК СхемаОбеспечения,
	|	Таблица.Склад КАК Склад
	|ПОМЕСТИТЬ Схемы
	|ИЗ
	|	РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК Таблица
	|ГДЕ
	|	Таблица.Номенклатура.СхемаОбеспечения <> ЗНАЧЕНИЕ(Справочник.СхемыОбеспечения.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Подразделение,
	|	Таблица.Номенклатура.СхемаОбеспечения,
	|	ЕСТЬNULL(&ТекстПолеСклад1, ТаблицаПодразделений.ИсточникОбеспечения) КАК Склад
	|ИЗ
	|	РегистрНакопления.МатериалыИРаботыВПроизводстве.Обороты(, , , ) КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ПО (ТаблицаПодразделений.Подразделение = Таблица.Подразделение)
	|	//ТекстСоединенияНастройкиПередачи1//
	|ГДЕ
	|	Таблица.Номенклатура.СхемаОбеспечения <> ЗНАЧЕНИЕ(Справочник.СхемыОбеспечения.ПустаяСсылка)
	|	И Таблица.Подразделение ССЫЛКА Справочник.СтруктураПредприятия
	|	И ВЫРАЗИТЬ(Таблица.Подразделение КАК Справочник.СтруктураПредприятия).ПроизводственноеПодразделение
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Этап.Подразделение,
	|	Таблица.Номенклатура.СхемаОбеспечения,
	|	ЕСТЬNULL(&ТекстПолеСклад2, ТаблицаПодразделений.ИсточникОбеспечения) КАК Склад
	|ИЗ
	|	Справочник.РесурсныеСпецификации.МатериалыИУслуги КАК Таблица
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ПО (ТаблицаПодразделений.Подразделение = Таблица.Этап.Подразделение)
	|	//ТекстСоединенияНастройкиПередачи2//
	|ГДЕ
	|	Таблица.Номенклатура.СхемаОбеспечения <> ЗНАЧЕНИЕ(Справочник.СхемыОбеспечения.ПустаяСсылка)
	|	И Таблица.Этап.Подразделение <> ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	СхемаОбеспечения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Схемы.Подразделение КАК Подразделение,
	|	Схемы.СхемаОбеспечения КАК СхемаОбеспечения,
	|	МАКСИМУМ(Схемы.Склад) КАК Склад
	|ИЗ
	|	Схемы КАК Схемы
	|
	|СГРУППИРОВАТЬ ПО
	|	Схемы.Подразделение,
	|	Схемы.СхемаОбеспечения
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Схемы.Склад) = 1";
	
	ШаблонЗапросаНастройкиПередачи1 = ПроизводствоСервер.ТекстЗапросаНастройкиПередачиМатериалов("Таблица",, Ложь);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстСоединенияНастройкиПередачи1//", ШаблонЗапросаНастройкиПередачи1.ТекстСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПолеСклад1", ШаблонЗапросаНастройкиПередачи1.ТекстПолеСклад);
	
	ШаблонЗапросаНастройкиПередачи2 = ПроизводствоСервер.ТекстЗапросаНастройкиПередачиМатериалов("Таблица", "Этап.Подразделение", Ложь);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ТекстСоединенияНастройкиПередачи2//", ШаблонЗапросаНастройкиПередачи2.ТекстСоединения);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ТекстПолеСклад2", ШаблонЗапросаНастройкиПередачи2.ТекстПолеСклад);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаПодразделений", ТаблицаПодразделений);
	Запрос.УстановитьПараметр("СкладПоУмолчанию", Справочники.Склады.СкладПоУмолчанию());
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		Запись = РегистрыСведений.СхемыОбеспеченияПроизводства.СоздатьМенеджерЗаписи();
		Запись.Подразделение = Выборка.Подразделение;
		Запись.СхемаОбеспечения = Выборка.СхемаОбеспечения;
		Запись.Склад = Выборка.Склад;
		Запись.Записать();
	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПоддержаниеЗапасовВКладовых()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаПодразделений.Подразделение,
	|	ТаблицаПодразделений.ЦеховаяКладовая,
	|	ТаблицаПодразделений.СрокИсполненияЗаказа,
	|	ТаблицаПодразделений.ОбеспечиваемыйПериод,
	|	ТаблицаПодразделений.ДлительностьПеремещения
	|ПОМЕСТИТЬ ТаблицаПодразделений
	|ИЗ
	|	&ТаблицаПодразделений КАК ТаблицаПодразделений
	|ГДЕ
	|	ТаблицаПодразделений.ЦеховаяКладовая <> ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаПередачи.Подразделение КАК Подразделение,
	|	НастройкаПередачи.Номенклатура КАК Номенклатура,
	|	НастройкаПередачи.Характеристика КАК Характеристика,
	|	НастройкаПередачи.Номенклатура.СхемаОбеспечения КАК СхемаОбеспечения,
	|	НастройкаПередачи.Склад КАК Склад
	|ПОМЕСТИТЬ НастройкаПередачи
	|ИЗ
	|	РегистрСведений.НастройкаПередачиМатериаловВПроизводство КАК НастройкаПередачи
	|ГДЕ
	|	НастройкаПередачи.ОснованиеДляПолучения = ЗНАЧЕНИЕ(Перечисление.ОснованияДляПолученияМатериаловВПроизводстве.ПоЗаказуНаВнутреннееПотребление)
	|	И НастройкаПередачи.Номенклатура.СхемаОбеспечения <> ЗНАЧЕНИЕ(Справочник.СхемыОбеспечения.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаПередачи.Подразделение КАК Подразделение,
	|	НастройкаПередачи.СхемаОбеспечения КАК СхемаОбеспечения,
	|	МАКСИМУМ(НастройкаПередачи.Склад) КАК Склад,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкаПередачи.Склад) КАК КоличествоСкладов
	|ПОМЕСТИТЬ НастройкаПередачиПоСхемам
	|ИЗ
	|	НастройкаПередачи КАК НастройкаПередачи
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаПередачи.Подразделение,
	|	НастройкаПередачи.СхемаОбеспечения
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Подразделение,
	|	СхемаОбеспечения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаПередачиПоСхемам.Подразделение КАК Подразделение,
	|	НастройкаПередачиПоСхемам.Подразделение.Наименование КАК ПодразделениеНаименование,
	|	НастройкаПередачиПоСхемам.СхемаОбеспечения КАК СхемаОбеспечения,
	|	НастройкаПередачиПоСхемам.Склад КАК Склад,
	|	НастройкаПередачиПоСхемам.Склад.Наименование КАК СкладНаименование,
	|	ТаблицаПодразделений.ЦеховаяКладовая КАК ЦеховаяКладовая,
	|	ТаблицаПодразделений.СрокИсполненияЗаказа КАК СрокИсполненияЗаказа,
	|	ТаблицаПодразделений.ОбеспечиваемыйПериод КАК ОбеспечиваемыйПериод,
	|	ТаблицаПодразделений.ДлительностьПеремещения КАК ДлительностьПеремещения,
	|	МАКСИМУМ(СуществующийСпособ.Ссылка) КАК СпособОбеспеченияПотребностей
	|ИЗ
	|	НастройкаПередачиПоСхемам КАК НастройкаПередачиПоСхемам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ПО (ТаблицаПодразделений.Подразделение = НастройкаПередачиПоСхемам.Подразделение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК СуществующаяНастройка
	|		ПО (СуществующаяНастройка.СхемаОбеспечения = НастройкаПередачиПоСхемам.СхемаОбеспечения)
	|			И (СуществующаяНастройка.Склад = ТаблицаПодразделений.ЦеховаяКладовая)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СуществующийСпособ
	|		ПО (СуществующийСпособ.Подразделение = НастройкаПередачиПоСхемам.Подразделение)
	|			И (СуществующийСпособ.ИсточникОбеспеченияПотребностей = НастройкаПередачиПоСхемам.Склад)
	|			И (СуществующийСпособ.ТипОбеспечения = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Перемещение))
	|ГДЕ
	|	НастройкаПередачиПоСхемам.КоличествоСкладов = 1
	|	И СуществующаяНастройка.СхемаОбеспечения ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаПередачиПоСхемам.Подразделение,
	|	НастройкаПередачиПоСхемам.СхемаОбеспечения,
	|	НастройкаПередачиПоСхемам.Склад,
	|	ТаблицаПодразделений.ЦеховаяКладовая,
	|	ТаблицаПодразделений.СрокИсполненияЗаказа,
	|	ТаблицаПодразделений.ОбеспечиваемыйПериод,
	|	ТаблицаПодразделений.ДлительностьПеремещения,
	|	НастройкаПередачиПоСхемам.Подразделение.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаПередачиПоСхемам.Подразделение КАК Подразделение,
	|	НастройкаПередачиПоСхемам.Подразделение.Наименование КАК ПодразделениеНаименование,
	|	НастройкаПередачи.Номенклатура КАК Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика,
	|	НастройкаПередачи.Склад КАК Склад,
	|	НастройкаПередачи.Склад.Наименование КАК СкладНаименование,
	|	ТаблицаПодразделений.ЦеховаяКладовая КАК ЦеховаяКладовая,
	|	ТаблицаПодразделений.СрокИсполненияЗаказа КАК СрокИсполненияЗаказа,
	|	ТаблицаПодразделений.ОбеспечиваемыйПериод КАК ОбеспечиваемыйПериод,
	|	ТаблицаПодразделений.ДлительностьПеремещения КАК ДлительностьПеремещения,
	|	МАКСИМУМ(СуществующийСпособ.Ссылка) КАК СпособОбеспеченияПотребностей
	|ИЗ
	|	НастройкаПередачиПоСхемам КАК НастройкаПередачиПоСхемам
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НастройкаПередачи КАК НастройкаПередачи
	|		ПО (НастройкаПередачи.Подразделение = НастройкаПередачиПоСхемам.Подразделение)
	|			И (НастройкаПередачи.СхемаОбеспечения = НастройкаПередачиПоСхемам.СхемаОбеспечения)
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СпрНоменклатура
	|		ПО СпрНоменклатура.Ссылка = НастройкаПередачи.Номенклатура
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ПО ХарактеристикиНоменклатуры.Ссылка = НастройкаПередачи.Характеристика
	|			ИЛИ НастройкаПередачи.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
	|				И (СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ИндивидуальныеДляНоменклатуры)
	|						И ХарактеристикиНоменклатуры.Владелец = СпрНоменклатура.Ссылка
	|					ИЛИ СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеДляВидаНоменклатуры)
	|						И ХарактеристикиНоменклатуры.Владелец = СпрНоменклатура.ВидНоменклатуры
	|					ИЛИ СпрНоменклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.ОбщиеСДругимВидомНоменклатуры)
	|						И ХарактеристикиНоменклатуры.Владелец = СпрНоменклатура.ВладелецХарактеристик)
	|				И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления
	|
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ПО (ТаблицаПодразделений.Подразделение = НастройкаПередачиПоСхемам.Подразделение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК СуществующаяНастройка
	|		ПО (СуществующаяНастройка.Номенклатура = НастройкаПередачи.Номенклатура)
	|			И (СуществующаяНастройка.Характеристика = ХарактеристикиНоменклатуры.Ссылка)
	|			И (СуществующаяНастройка.Склад = ТаблицаПодразделений.ЦеховаяКладовая)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СуществующийСпособ
	|		ПО (СуществующийСпособ.Подразделение = НастройкаПередачиПоСхемам.Подразделение)
	|			И (СуществующийСпособ.ИсточникОбеспеченияПотребностей = НастройкаПередачи.Склад)
	|			И (СуществующийСпособ.ТипОбеспечения = ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.Перемещение))
	|ГДЕ
	|	НастройкаПередачиПоСхемам.КоличествоСкладов > 1
	|	И (НЕ ХарактеристикиНоменклатуры.Ссылка ЕСТЬ NULL
	|		ИЛИ НастройкаПередачи.Номенклатура.ИспользованиеХарактеристик = ЗНАЧЕНИЕ(Перечисление.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать))
	|	И СуществующаяНастройка.Склад ЕСТЬ NULL 
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаПередачиПоСхемам.Подразделение,
	|	НастройкаПередачи.Номенклатура,
	|	ХарактеристикиНоменклатуры.Ссылка,
	|	НастройкаПередачи.Склад,
	|	ТаблицаПодразделений.ЦеховаяКладовая,
	|	ТаблицаПодразделений.СрокИсполненияЗаказа,
	|	ТаблицаПодразделений.ОбеспечиваемыйПериод,
	|	ТаблицаПодразделений.ДлительностьПеремещения,
	|	НастройкаПередачиПоСхемам.Подразделение.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаПередачи.Номенклатура КАК Номенклатура,
	|	НастройкаПередачи.Характеристика КАК Характеристика,
	|	ТаблицаПодразделений.ЦеховаяКладовая КАК ЦеховаяКладовая
	|ИЗ
	|	НастройкаПередачи КАК НастройкаПередачи
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаПодразделений КАК ТаблицаПодразделений
	|		ПО (ТаблицаПодразделений.Подразделение = НастройкаПередачи.Подразделение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныеОграничения КАК ТоварныеОграничения
	|		ПО &ПодстановкаТоварногоОграничения
	|ГДЕ
	|	ТоварныеОграничения.Склад ЕСТЬ NULL ";
	
	ПоляСоединения = "НастройкаПередачи.Номенклатура,НастройкаПередачи.Характеристика,ТаблицаПодразделений.ЦеховаяКладовая";
	ТекстЗапроса = РегистрыСведений.ТоварныеОграничения.ПодставитьСоединение(ТекстЗапроса,
		"ПодстановкаТоварногоОграничения", ПоляСоединения);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаПодразделений", ТаблицаПодразделений);
	
	Результат = Запрос.ВыполнитьПакет();
	
	СозданныеСпособыОбеспечения = Новый Соответствие;
	
	// Заполнение настроек в схемах обеспечения
	Выборка = Результат[Результат.ВГраница()-2].Выбрать();
	Пока Выборка.Следующий() Цикл

		СпособПодразделения = ПолучитьСпособОбеспечения(Выборка);
		
		Если СпособПодразделения <> Неопределено Тогда
			РегистрыСведений.СхемыОбеспечения.Добавить(
				Выборка.ЦеховаяКладовая, 
				Выборка.СхемаОбеспечения, 
				СпособПодразделения);
		КонецЕсли; 
		
	КонецЦикла;
	
	// Заполнение индивидуальных настроек
	Выборка = Результат[Результат.ВГраница()-1].выбрать();
	Пока Выборка.Следующий() Цикл
		
		СпособПодразделения = ПолучитьСпособОбеспечения(Выборка);
		
		Если СпособПодразделения <> Неопределено Тогда
			ЗаписьРегистра = РегистрыСведений.ВариантыОбеспеченияТоварами.СоздатьМенеджерЗаписи();
			ЗаписьРегистра.Склад = Выборка.ЦеховаяКладовая;
			ЗаписьРегистра.Номенклатура = Выборка.Номенклатура;
			ЗаписьРегистра.Характеристика = Выборка.Характеристика;
			ЗаписьРегистра.СпособОбеспеченияПотребностей = СпособПодразделения;
			ЗаписьРегистра.РеквизитДопУпорядочивания = 1;
			ЗаписьРегистра.Записать();
		КонецЕсли; 
		
	КонецЦикла;
	
	// Указание что для материалов поддерживаются запасы
	Выборка = Результат[Результат.ВГраница()].Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ЗначениеЗаполнено(Выборка.Характеристика) Тогда
			КлючЗаписи = РегистрыСведений.ТоварныеОграничения.КлючЗаписиХарактеристики();
			КлючЗаписи.Характеристика = Выборка.Характеристика;
		Иначе
			КлючЗаписи = РегистрыСведений.ТоварныеОграничения.КлючЗаписиНоменклатуры();
		КонецЕсли;
		КлючЗаписи.Номенклатура	= Выборка.Номенклатура;
		КлючЗаписи.Склад		= Выборка.ЦеховаяКладовая;
		РегистрыСведений.ТоварныеОграничения.ДобавитьПоддержаниеЗапасаМинМакс(КлючЗаписи);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСпособОбеспечения(РеквизитыСпособа)

	Если ЗначениеЗаполнено(РеквизитыСпособа.СпособОбеспеченияПотребностей) Тогда
		Возврат РеквизитыСпособа.СпособОбеспеченияПотребностей;
	КонецЕсли; 

	СтруктураПоиска = Новый Структура("Подразделение,ИсточникОбеспечения", РеквизитыСпособа.Подразделение, РеквизитыСпособа.Склад);
 	СписокСтрок = СпособыОбеспечения.НайтиСтроки(СтруктураПоиска);
	Если СписокСтрок.Количество() <> 0 Тогда
		Возврат СписокСтрок[0].СпособОбеспечения;
	КонецЕсли; 
	
	НаименованиеСпособа = СтрШаблон(НСтр("ru = 'Передача в кладовую подразделения ""%1"" со склада ""%2""'"),
									РеквизитыСпособа.ПодразделениеНаименование,
									РеквизитыСпособа.СкладНаименование);
	
	СпособОбеспечения = Справочники.СпособыОбеспеченияПотребностей.СоздатьЭлемент();
	
	СпособОбеспечения.Заполнить(Неопределено);
	СпособОбеспечения.Наименование = НаименованиеСпособа;
	СпособОбеспечения.ТипОбеспечения = Перечисления.ТипыОбеспечения.Перемещение;
	СпособОбеспечения.Подразделение = РеквизитыСпособа.Подразделение;
	СпособОбеспечения.СрокИсполненияЗаказа = РеквизитыСпособа.СрокИсполненияЗаказа;
	СпособОбеспечения.ОбеспечиваемыйПериод = РеквизитыСпособа.ОбеспечиваемыйПериод;
	СпособОбеспечения.ДлительностьВДнях = РеквизитыСпособа.ДлительностьПеремещения;
	СпособОбеспечения.ИсточникОбеспеченияПотребностей = РеквизитыСпособа.Склад;
	
	Если НЕ СпособОбеспечения.ПроверитьЗаполнение() Тогда
		ТекстОшибки = НСтр("ru = 'При проверке заполнения нового способа обеспечения возникли ошибки. Обратитесь к администратору.'");
		ДобавитьОшибку(ТекстОшибки);
		Возврат Неопределено;
	КонецЕсли;
	
	СпособОбеспечения.Записать();

	НовыйСпособ = СпособыОбеспечения.Добавить();
	НовыйСпособ.Подразделение = РеквизитыСпособа.Подразделение;
	НовыйСпособ.ИсточникОбеспечения = РеквизитыСпособа.Склад;
	НовыйСпособ.СпособОбеспечения = СпособОбеспечения.Ссылка;
	
	Возврат СпособОбеспечения.Ссылка;
	
КонецФункции

&НаСервере
Функция НайтиСтрокуВСпискеРекурсивно(Подразделение, КоллекцияСтрок)

	Для каждого СтрокаСписка Из КоллекцияСтрок Цикл
		Если СтрокаСписка.Подразделение = Подразделение Тогда
			Возврат СтрокаСписка;
		КонецЕсли;
		НайденнаяСтрока = НайтиСтрокуВСпискеРекурсивно(Подразделение, СтрокаСписка.ПолучитьЭлементы());
		Если НайденнаяСтрока <> Неопределено Тогда
			Возврат НайденнаяСтрока;
		КонецЕсли; 
	КонецЦикла; 

	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ВосстановитьНастройкиСпискаПодразделений(КоллекцияСтрок)

	СохраняемыеРеквизиты = "СрокИсполненияЗаказа,ОбеспечиваемыйПериод,ДлительностьПеремещения,СоздатьКладовую,ИсточникОбеспечения";
	
	Для каждого СтрокаСохраненнойНастройки Из КоллекцияСтрок Цикл
		
		СтрокаПодразделение = НайтиСтрокуВСпискеРекурсивно(СтрокаСохраненнойНастройки.Подразделение, СписокПодразделений.ПолучитьЭлементы());
		Если СтрокаПодразделение <> Неопределено Тогда
			
			Если НЕ ОбщегоНазначенияУТКлиентСервер.СтруктурыРавны(СтрокаСохраненнойНастройки, СтрокаПодразделение, СохраняемыеРеквизиты) Тогда
				ЗаполнитьЗначенияСвойств(СтрокаПодразделение, СтрокаСохраненнойНастройки, СохраняемыеРеквизиты);
				НастройкиВосстановлены = Истина;
			КонецЕсли;
			
		КонецЕсли; 
		
		ВосстановитьНастройкиСпискаПодразделений(СтрокаСохраненнойНастройки.Строки);
		
	КонецЦикла; 

КонецПроцедуры

&НаСервере
Процедура ДобавитьОшибку(ТекстОшибки, Ссылка = Неопределено)

	ЕстьОшибки = Истина;
	
	ИмяСобытия = НСтр("ru = 'Переход на управление производством 2_2.Создание кладовых'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка); 
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,, Ссылка, ТекстОшибки);

КонецПроцедуры

#КонецОбласти

