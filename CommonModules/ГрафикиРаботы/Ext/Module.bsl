﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Графики работы".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция возвращает массив дат, которые отличается указанной даты на количество дней,
// входящих в указанный график.
//
// Параметры:
//	ГрафикРаботы	- график , который необходимо использовать, тип СправочникСсылка.Календари.
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата.
//	МассивДней		- массив с количеством дней, на которые нужно увеличить дату начала, тип Массив,Число.
//	РассчитыватьСледующуюДатуОтПредыдущей	- нужно ли рассчитывать следующую дату от предыдущей или
//											  все даты рассчитываются от переданной даты.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//
// Возвращаемое значение
//	Массив		- массив дат, увеличенных на количество дней, входящих в график,
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ДатыПоГрафику(Знач ГрафикРаботы, Знач ДатаОт, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь, ВызыватьИсключение = Истина) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	КалендарныеГрафики.СоздатьВТПриращениеДней(МенеджерВременныхТаблиц, МассивДней, РассчитыватьСледующуюДатуОтПредыдущей);
	
	// Алгоритм работает следующим образом:
	// Получаем количество включенных в график дней на дату отсчета.
	// Для всех последующих годов получаем "смещение" количества дней в виде суммы количества дней предыдущих годов.
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.Год,
	|	МАКСИМУМ(КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода) КАК ДнейВГрафике
	|ПОМЕСТИТЬ ВТКоличествоДнейВГрафикеПоГодам
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.ДатаГрафика >= &ДатаОт
	|	И КалендарныеГрафики.Календарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|
	|СГРУППИРОВАТЬ ПО
	|	КалендарныеГрафики.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоличествоДнейВГрафикеПоГодам.Год,
	|	СУММА(ЕСТЬNULL(КоличествоДнейПредыдущихГодов.ДнейВГрафике, 0)) КАК ДнейВГрафике
	|ПОМЕСТИТЬ ВТКоличествоДнейСУчетомПредыдущихГодов
	|ИЗ
	|	ВТКоличествоДнейВГрафикеПоГодам КАК КоличествоДнейВГрафикеПоГодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоличествоДнейВГрафикеПоГодам КАК КоличествоДнейПредыдущихГодов
	|		ПО (КоличествоДнейПредыдущихГодов.Год < КоличествоДнейВГрафикеПоГодам.Год)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоДнейВГрафикеПоГодам.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода) КАК КоличествоДнейВГрафикеСНачалаГода
	|ПОМЕСТИТЬ ВТКоличествоДнейВГрафикеНаДатуОтсчета
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.ДатаГрафика >= &ДатаОт
	|	И КалендарныеГрафики.Год = ГОД(&ДатаОт)
	|	И КалендарныеГрафики.Календарь = &ГрафикРаботы
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки,
	|	ЕСТЬNULL(КалендарныеГрафики.ДатаГрафика, НЕОПРЕДЕЛЕНО) КАК ДатаПоКалендарю
	|ИЗ
	|	ВТПриращениеДней КАК ПриращениеДней
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоличествоДнейВГрафикеНаДатуОтсчета КАК КоличествоДнейВГрафикеНаДатуОтсчета
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоличествоДнейСУчетомПредыдущихГодов КАК КоличествоДнейСУчетомПредыдущихГодов
	|			ПО (КоличествоДнейСУчетомПредыдущихГодов.Год = КалендарныеГрафики.Год)
	|		ПО (КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеНаДатуОтсчета.КоличествоДнейВГрафикеСНачалаГода - КоличествоДнейСУчетомПредыдущихГодов.ДнейВГрафике + ПриращениеДней.КоличествоДней)
	|			И (КалендарныеГрафики.ДатаГрафика >= &ДатаОт)
	|			И (КалендарныеГрафики.Календарь = &ГрафикРаботы)
	|			И (КалендарныеГрафики.ДеньВключенВГрафик)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриращениеДней.ИндексСтроки";
	
	Запрос.УстановитьПараметр("ДатаОт", НачалоДня(ДатаОт));
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивДат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаПоКалендарю = Неопределено Тогда
			СообщениеОбОшибке = НСтр("ru = 'График работы «%1» не заполнен с даты %2 на указанное количество рабочих дней.'");
			Если ВызыватьИсключение Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, ГрафикРаботы, Формат(ДатаОт, "ДЛФ=D"));
			Иначе
				Возврат Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		МассивДат.Добавить(Выборка.ДатаПоКалендарю);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

// Функция возвращает дату, которая отличается указанной даты на количество дней,
// входящих в указанный график.
//
// Параметры:
//	ГрафикРаботы	- график, который необходимо использовать, тип СправочникСсылка.Календари.
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата.
//	КоличествоДней	- количество дней, на которые нужно увеличить дату начала, тип Число.
//	ВызыватьИсключение - булево, если Истина вызывается исключение в случае незаполненного графика.
//
// Возвращаемое значение
//	Дата			- дата, увеличенная на количество дней, входящих в график.
//	Если выбранный график не заполнен, и ВызыватьИсключение = Ложь, возвращается Неопределено.
//
Функция ДатаПоГрафику(Знач ГрафикРаботы, Знач ДатаОт, Знач КоличествоДней, ВызыватьИсключение = Истина) Экспорт
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	МассивДней = Новый Массив;
	МассивДней.Добавить(КоличествоДней);
	
	МассивДат = ДатыПоГрафику(ГрафикРаботы, ДатаОт, МассивДней, , ВызыватьИсключение);
	
	Возврат ?(МассивДат <> Неопределено, МассивДат[0], Неопределено);
	
КонецФункции

// Составляет расписания работы для дат, включенных в указанные графики на указанный период.
// Если расписание на предпраздничный день не задано, то оно определяется так, как если бы этот день был бы рабочим.
//
// Параметры:
//	Графики - массив элементов типа СправочникСсылка.Календари.
//	ДатаНачала - дата начала периода, за который нужно составить расписания.
//	ДатаОкончания - дата окончания периода.
//
// Возвращаемое значение - таблица значений с колонками.
//	ГрафикРаботы
//	ДатаГрафика
//	ВремяНачала
//	ВремяОкончания
//
Функция РасписанияРаботыНаПериод(Графики, ДатаНачала, ДатаОкончания) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	// Создаем временную таблицу расписаний.
	СоздатьВТРасписанияРаботыНаПериод(МенеджерВременныхТаблиц, Графики, ДатаНачала, ДатаОкончания);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	РасписанияРаботы.ГрафикРаботы,
	|	РасписанияРаботы.ДатаГрафика,
	|	РасписанияРаботы.ВремяНачала,
	|	РасписанияРаботы.ВремяОкончания
	|ИЗ
	|	ВТРасписанияРаботы КАК РасписанияРаботы";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Создает в менеджере временную таблицу ВТРасписанияРаботы с колонками.
// Подробнее см. комментарий к функции РасписанияРаботыНаПериод.
//
Процедура СоздатьВТРасписанияРаботыНаПериод(МенеджерВременныхТаблиц, Графики, ДатаНачала, ДатаОкончания) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ШаблонЗаполнения.Ссылка КАК ГрафикРаботы,
	|	МАКСИМУМ(ШаблонЗаполнения.НомерСтроки) КАК ДлинаЦикла
	|ПОМЕСТИТЬ ВТДлинаЦиклаГрафиков
	|ИЗ
	|	Справочник.Календари.ШаблонЗаполнения КАК ШаблонЗаполнения
	|ГДЕ
	|	ШаблонЗаполнения.Ссылка В(&Календари)
	|
	|СГРУППИРОВАТЬ ПО
	|	ШаблонЗаполнения.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Календари.Ссылка КАК ГрафикРаботы,
	|	ДанныеПроизводственногоКалендаря.Дата КАК ДатаГрафика,
	|	ВЫБОР
	|		КОГДА ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ПредпраздничныйДень
	|ПОМЕСТИТЬ ВТПредпраздничныеДни
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	|		ПО ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = Календари.ПроизводственныйКалендарь
	|			И (Календари.Ссылка В (&Календари))
	|			И (ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|			И (ДанныеПроизводственногоКалендаря.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Календари.Ссылка КАК ГрафикРаботы,
	|	ДанныеПроизводственногоКалендаря.Дата КАК ДатаГрафика,
	|	ДанныеПроизводственногоКалендаря.ДатаПереноса
	|ПОМЕСТИТЬ ВТДатыПереноса
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	|		ПО ДанныеПроизводственногоКалендаря.ПроизводственныйКалендарь = Календари.ПроизводственныйКалендарь
	|			И (Календари.Ссылка В (&Календари))
	|			И (ДанныеПроизводственногоКалендаря.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|			И (ДанныеПроизводственногоКалендаря.ДатаПереноса <> ДАТАВРЕМЯ(1, 1, 1))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КалендарныеГрафики.Календарь КАК ГрафикРаботы,
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика,
	|	РАЗНОСТЬДАТ(Календари.ДатаОтсчета, КалендарныеГрафики.ДатаГрафика, ДЕНЬ) + 1 КАК ДнейОтДатыОтсчета,
	|	ПредпраздничныеДни.ПредпраздничныйДень,
	|	ДатыПереноса.ДатаПереноса
	|ПОМЕСТИТЬ ВТДниВключенныеВГрафик
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	|		ПО КалендарныеГрафики.Календарь = Календари.Ссылка
	|			И (КалендарныеГрафики.Календарь В (&Календари))
	|			И (КалендарныеГрафики.ДатаГрафика МЕЖДУ &ДатаНачала И &ДатаОкончания)
	|			И (КалендарныеГрафики.ДеньВключенВГрафик)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТПредпраздничныеДни КАК ПредпраздничныеДни
	|		ПО (ПредпраздничныеДни.ГрафикРаботы = КалендарныеГрафики.Календарь)
	|			И (ПредпраздничныеДни.ДатаГрафика = КалендарныеГрафики.ДатаГрафика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТДатыПереноса КАК ДатыПереноса
	|		ПО (ДатыПереноса.ГрафикРаботы = КалендарныеГрафики.Календарь)
	|			И (ДатыПереноса.ДатаГрафика = КалендарныеГрафики.ДатаГрафика)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДниВключенныеВГрафик.ГрафикРаботы,
	|	ДниВключенныеВГрафик.ДатаГрафика,
	|	ВЫБОР
	|		КОГДА ДниВключенныеВГрафик.РезультатДеленияПоМодулю = 0
	|			ТОГДА ДниВключенныеВГрафик.ДлинаЦикла
	|		ИНАЧЕ ДниВключенныеВГрафик.РезультатДеленияПоМодулю
	|	КОНЕЦ КАК НомерДня,
	|	ДниВключенныеВГрафик.ПредпраздничныйДень
	|ПОМЕСТИТЬ ВТДатыНомераДней
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДниВключенныеВГрафик.ГрафикРаботы КАК ГрафикРаботы,
	|		ДниВключенныеВГрафик.ДатаГрафика КАК ДатаГрафика,
	|		ДниВключенныеВГрафик.ПредпраздничныйДень КАК ПредпраздничныйДень,
	|		ДниВключенныеВГрафик.ДлинаЦикла КАК ДлинаЦикла,
	|		ДниВключенныеВГрафик.ДнейОтДатыОтсчета - ДниВключенныеВГрафик.ЦелаяЧастьРезультатаДеления * ДниВключенныеВГрафик.ДлинаЦикла КАК РезультатДеленияПоМодулю
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ДниВключенныеВГрафик.ГрафикРаботы КАК ГрафикРаботы,
	|			ДниВключенныеВГрафик.ДатаГрафика КАК ДатаГрафика,
	|			ДниВключенныеВГрафик.ПредпраздничныйДень КАК ПредпраздничныйДень,
	|			ДниВключенныеВГрафик.ДнейОтДатыОтсчета КАК ДнейОтДатыОтсчета,
	|			ДлинаЦиклов.ДлинаЦикла КАК ДлинаЦикла,
	|			(ВЫРАЗИТЬ(ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла КАК ЧИСЛО(15, 0))) - ВЫБОР
	|				КОГДА (ВЫРАЗИТЬ(ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла КАК ЧИСЛО(15, 0))) > ДниВключенныеВГрафик.ДнейОтДатыОтсчета / ДлинаЦиклов.ДлинаЦикла
	|					ТОГДА 1
	|				ИНАЧЕ 0
	|			КОНЕЦ КАК ЦелаяЧастьРезультатаДеления
	|		ИЗ
	|			ВТДниВключенныеВГрафик КАК ДниВключенныеВГрафик
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	|				ПО ДниВключенныеВГрафик.ГрафикРаботы = Календари.Ссылка
	|					И (Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоЦикламПроизвольнойДлины))
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДлинаЦиклаГрафиков КАК ДлинаЦиклов
	|				ПО ДниВключенныеВГрафик.ГрафикРаботы = ДлинаЦиклов.ГрафикРаботы) КАК ДниВключенныеВГрафик) КАК ДниВключенныеВГрафик
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДниВключенныеВГрафик.ГрафикРаботы,
	|	ДниВключенныеВГрафик.ДатаГрафика,
	|	ВЫБОР
	|		КОГДА ДниВключенныеВГрафик.ДатаПереноса ЕСТЬ NULL 
	|			ТОГДА ДЕНЬНЕДЕЛИ(ДниВключенныеВГрафик.ДатаГрафика)
	|		ИНАЧЕ ДЕНЬНЕДЕЛИ(ДниВключенныеВГрафик.ДатаПереноса)
	|	КОНЕЦ,
	|	ДниВключенныеВГрафик.ПредпраздничныйДень
	|ИЗ
	|	ВТДниВключенныеВГрафик КАК ДниВключенныеВГрафик
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Календари КАК Календари
	|		ПО ДниВключенныеВГрафик.ГрафикРаботы = Календари.Ссылка
	|ГДЕ
	|	Календари.СпособЗаполнения = ЗНАЧЕНИЕ(Перечисление.СпособыЗаполненияГрафикаРаботы.ПоНеделям)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДниВключенныеВГрафик.ГрафикРаботы,
	|	ДниВключенныеВГрафик.ДатаГрафика,
	|	ДниВключенныеВГрафик.НомерДня,
	|	ЕСТЬNULL(РасписанияРаботыПредпраздничногоДня.ВремяНачала, РасписанияРаботы.ВремяНачала) КАК ВремяНачала,
	|	ЕСТЬNULL(РасписанияРаботыПредпраздничногоДня.ВремяОкончания, РасписанияРаботы.ВремяОкончания) КАК ВремяОкончания
	|ПОМЕСТИТЬ ВТРасписанияРаботы
	|ИЗ
	|	ВТДатыНомераДней КАК ДниВключенныеВГрафик
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Календари.РасписаниеРаботы КАК РасписанияРаботы
	|		ПО (РасписанияРаботы.Ссылка = ДниВключенныеВГрафик.ГрафикРаботы)
	|			И (РасписанияРаботы.НомерДня = ДниВключенныеВГрафик.НомерДня)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Календари.РасписаниеРаботы КАК РасписанияРаботыПредпраздничногоДня
	|		ПО (РасписанияРаботыПредпраздничногоДня.Ссылка = ДниВключенныеВГрафик.ГрафикРаботы)
	|			И (РасписанияРаботыПредпраздничногоДня.НомерДня = 0)
	|			И (ДниВключенныеВГрафик.ПредпраздничныйДень)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ДниВключенныеВГрафик.ГрафикРаботы,
	|	ДниВключенныеВГрафик.ДатаГрафика";
	
	// Для вычисления номера в цикле произвольной длины для дня, включенного в график, используется следующая формула:
	// Номер дня = Дней от даты отсчета % Длина цикла, где % - операция деления по модулю.
	
	// Операция деления по модулю в свою очередь производится по формуле:
	// Делимое - Цел(Делимое / Делитель) * Делитель, где Цел() - функция выделения целой части.
	
	// Для выделения целой части используется конструкция:
	// если результат округления числа по правилам «1.5 как 2» больше исходного значения, уменьшаем результат на 1.
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Календари", Графики);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет обновление графиков работы по данным производственных календарей, 
// на основании которых они заполняются.
//
// Параметры:
//	- УсловияОбновления - таблица значений с колонками.
//		- КодПроизводственногоКалендаря - код производственного календаря, данные которого изменились,
//		- Год - год, за который нужно обновить данные.
//
Процедура ОбновитьГрафикиРаботыПоДаннымПроизводственныхКалендарей(УсловияОбновления) Экспорт
	
	Справочники.Календари.ОбновитьГрафикиРаботыПоДаннымПроизводственныхКалендарей(УсловияОбновления);
	
КонецПроцедуры

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики[
		"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"
	].Добавить("ГрафикиРаботы");
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// СовместноДляПользователейИВнешнихПользователей.
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ЧтениеГрафиковРаботы.Имя);
	
КонецПроцедуры

// Создает временную таблицу ВТКалендарныеГрафики, содержащую данные графика ГрафикРаботы за годы, 
// приведенные в ВТРазличныеГодыГрафика.
//
// Параметры:
//	- МенеджерВременныхТаблиц - должен содержать ВТРазличныеГодыГрафика с полем Год, типа Число (4,0),
//	- ГрафикРаботы - график, который необходимо использовать, тип СправочникСсылка.Календари.
//
Процедура СоздатьВТДанныеГрафика(МенеджерВременныхТаблиц, ГрафикРаботы) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	КалендарныеГрафики.Год,
	|	КалендарныеГрафики.ДатаГрафика,
	|	КалендарныеГрафики.ДеньВключенВГрафик
	|ПОМЕСТИТЬ ВТКалендарныеГрафики
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТРазличныеГодыГрафика КАК ГодыГрафика
	|		ПО (ГодыГрафика.Год = КалендарныеГрафики.Год)
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &ГрафикРаботы";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ГрафикРаботы", ГрафикРаботы);
	Запрос.Выполнить();
	
КонецПроцедуры

// Формирует шаблон текста запроса, встраиваемый в методе КалендарныеГрафики.ПолучитьДатыРабочихДней.
//
Функция ШаблонТекстаЗапросаОпределенияБлижайшихДатПоГрафикуРаботы() Экспорт
	
	Возврат
	"ВЫБРАТЬ
	|	НачальныеДаты.Дата,
	|	%Функция%(ДатыКалендаря.ДатаГрафика) КАК БлижайшаяДата
	|ИЗ
	|	НачальныеДаты КАК НачальныеДаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК ДатыКалендаря
	|		ПО (ДатыКалендаря.ДатаГрафика %ЗнакУсловия% НачальныеДаты.Дата)
	|			И (ДатыКалендаря.Календарь = &График)
	|			И (ДатыКалендаря.ДеньВключенВГрафик)
	|
	|СГРУППИРОВАТЬ ПО
	|	НачальныеДаты.Дата";
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов в другие подсистемы.

// Процедура выполняет обновление графиков работы по данным производственных календарей 
// по всем областям данных.
//
Процедура ЗапланироватьОбновлениеГрафиковРаботы(Знач УсловияОбновления) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.КалендарныеГрафикиВМоделиСервиса") Тогда
		МодульКалендарныеГрафикиСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("КалендарныеГрафикиСлужебныйВМоделиСервиса");
		МодульКалендарныеГрафикиСлужебныйВМоделиСервиса.ЗапланироватьОбновлениеГрафиковРаботы(УсловияОбновления);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы.

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "ГрафикиРаботы.СоздатьКалендарьПятидневкаРоссийскойФедерации";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.1";
	Обработчик.Процедура = "ГрафикиРаботы.ЗаполнитьНастройкиЗаполненияГрафиковРаботы";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.2.14";
	Обработчик.Процедура = "ГрафикиРаботы.ЗаполнитьКоличествоДнейВГрафикеСНачалаГода";
	
КонецПроцедуры

// Процедура создает график работы на основе производственного календаря.
// Российской Федерации по шаблону "Пятидневка".
//
Процедура СоздатьКалендарьПятидневкаРоссийскойФедерации() Экспорт
	
	ПроизводственныйКалендарь = КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации();
	Если ПроизводственныйКалендарь = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не Справочники.Календари.НайтиПоРеквизиту("ПроизводственныйКалендарь", ПроизводственныйКалендарь).Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	НовыйГрафикРаботы = Справочники.Календари.СоздатьЭлемент();
	НовыйГрафикРаботы.Наименование = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроизводственныйКалендарь, "Наименование");
	НовыйГрафикРаботы.ПроизводственныйКалендарь = ПроизводственныйКалендарь;
	НовыйГрафикРаботы.СпособЗаполнения = Перечисления.СпособыЗаполненияГрафикаРаботы.ПоНеделям;
	НовыйГрафикРаботы.ДатаНачала = НачалоГода(ТекущаяДатаСеанса());
	НовыйГрафикРаботы.УчитыватьПраздники = Истина;
	
	// Заполняем недельный цикл как пятидневку.
	Для НомерДня = 1 По 7 Цикл
		НовыйГрафикРаботы.ШаблонЗаполнения.Добавить().ДеньВключенВГрафик = НомерДня <= 5;
	КонецЦикла;
	
	ОбновлениеИнформационнойБазы.ЗаписатьДанные(НовыйГрафикРаботы, Истина, Истина);
	
КонецПроцедуры

// Заполняет вторичные данные для оптимизации расчета дат по календарю.
//
Процедура ЗаполнитьКоличествоДнейВГрафикеСНачалаГода() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДанныеПроизводственногоКалендаря.Дата,
	|	ДанныеПроизводственногоКалендаря.Год
	|ПОМЕСТИТЬ ВТДаты
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Даты.Год,
	|	КОЛИЧЕСТВО(Даты.Дата) КАК КоличествоДней
	|ПОМЕСТИТЬ ВТКоличествоДнейПоГодам
	|ИЗ
	|	ВТДаты КАК Даты
	|
	|СГРУППИРОВАТЬ ПО
	|	Даты.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КалендарныеГрафики.Календарь,
	|	КалендарныеГрафики.Год,
	|	КОЛИЧЕСТВО(КалендарныеГрафики.ДатаГрафика) КАК КоличествоДней
	|ПОМЕСТИТЬ ВТКоличествоДнейПоГрафикам
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|
	|СГРУППИРОВАТЬ ПО
	|	КалендарныеГрафики.Календарь,
	|	КалендарныеГрафики.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоличествоДнейПоГрафикам.Календарь,
	|	КоличествоДнейПоГрафикам.Год
	|ПОМЕСТИТЬ ВТГрафикиГоды
	|ИЗ
	|	ВТКоличествоДнейПоГрафикам КАК КоличествоДнейПоГрафикам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоличествоДнейПоГодам КАК КоличествоДнейПоГодам
	|		ПО КоличествоДнейПоГрафикам.Год = КоличествоДнейПоГодам.Год
	|			И КоличествоДнейПоГрафикам.КоличествоДней < КоличествоДнейПоГодам.КоличествоДней
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГрафикиГоды.Календарь КАК Календарь,
	|	ГрафикиГоды.Год КАК Год,
	|	Даты.Дата КАК ДатаГрафика,
	|	ЕСТЬNULL(КалендарныеГрафики.ДеньВключенВГрафик, ЛОЖЬ) КАК ДеньВключенВГрафик
	|ИЗ
	|	ВТГрафикиГоды КАК ГрафикиГоды
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДаты КАК Даты
	|		ПО ГрафикиГоды.Год = Даты.Год
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|		ПО (КалендарныеГрафики.Календарь = ГрафикиГоды.Календарь)
	|			И (КалендарныеГрафики.Год = ГрафикиГоды.Год)
	|			И (КалендарныеГрафики.ДатаГрафика = Даты.Дата)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ГрафикиГоды.Календарь,
	|	ГрафикиГоды.Год,
	|	Даты.Дата
	|ИТОГИ ПО
	|	Календарь,
	|	Год";
	
	// Выбираем графики работы и годы, для которых не заполнено значение ресурса КоличествоДнейВГрафикеСНачалаГода,
	// заполняем для них последовательно рассчитывая количество дней.
	
	Запрос = Новый Запрос(ТекстЗапроса);
	ВыборкаПоГрафикам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоГрафикам.Следующий() Цикл
		ВыборкаПоГодам = ВыборкаПоГрафикам.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоГодам.Следующий() Цикл
			НаборЗаписей = РегистрыСведений.КалендарныеГрафики.СоздатьНаборЗаписей();
			КоличествоДнейВГрафикеСНачалаГода = 0;
			Выборка = ВыборкаПоГодам.Выбрать();
			Пока Выборка.Следующий() Цикл
				Если Выборка.ДеньВключенВГрафик Тогда
					КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеСНачалаГода + 1;
				КонецЕсли;
				СтрокаНабора = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаНабора, Выборка);
				СтрокаНабора.КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеСНачалаГода;
			КонецЦикла;
			НаборЗаписей.Отбор.Календарь.Установить(ВыборкаПоГодам.Календарь);
			НаборЗаписей.Отбор.Год.Установить(ВыборкаПоГодам.Год);
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
